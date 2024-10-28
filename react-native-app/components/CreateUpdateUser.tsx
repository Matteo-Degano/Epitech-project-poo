import React, { useEffect, useState } from 'react';
import { PaperProvider } from 'react-native-paper';
import { View, ScrollView, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { Checkbox, Dialog, Portal, Button, TextInput, RadioButton } from 'react-native-paper';
import { fetchData } from '@/app/service/api';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useNavigation } from '@react-navigation/native';

interface RouteParams {
    params: { 
        value?: object;
        isEditing?: boolean;
    };
}

const CreateUpdateUser = ({route}: { route: RouteParams }) => {
    const [username, setUsername] = useState();
    const [email, setEmail] = useState();
    const [password, setPassword] = useState();
    const [teams, setTeams] = useState<Array<{ id: number, name: string }>>([]);
    const [checkedTeams, setCheckedTeams] = useState<number[]>([]);
    const [roleId, setRoleId] = useState<number | null>(null);
    const [isUpdate, setIsUpdate] = useState<boolean | null>(null);
    const [userIdToUpdate, setUserIdToUpdate] = useState<boolean | null>(null);
    const [selectedRole, setSelectedRole] = useState<number | null>(null);
   
    const roles = [
    { label: 'Employée', value: 1 },
    { label: 'Manager', value: 2 },
    { label: 'Général Manager', value: 3 },
    { label: 'Admin', value: 4 },
];

    const navigation = useNavigation(); 

    const [visible, setVisible] = React.useState(false);
    const showDialog = () => setVisible(true);
    const hideDialog = () => setVisible(false);

    const loadUserData = async () => {
        const roleIdString = await AsyncStorage.getItem('roleId');
        const roleId = roleIdString !== null ? Number(roleIdString) : null;
        setRoleId(roleId);
    };

    const loadTeamsData = async () => {
        try {
            const response = await fetchData("GET", `/teams`);
            if (response && response.data.data && response.data.data.length > 0) {
                setTeams(response.data.data);
            } else {
                console.error("Teams data is not an array or is missing:", response);
            }
        } catch (error) {
            console.error("Error fetching teams data:", error);
        }
    };

    useEffect(() => {
        const fetchData = async () => {
            await Promise.all([loadUserData(), loadTeamsData()]);
        };
        fetchData();
    }, []);

    useEffect(() => {
        const fetchUserData = async () => {
        const { isEditing, value } = route.params;
        
        setIsUpdate(isEditing ?? null);


        if(isEditing){

            const userId = value?.id

            setUserIdToUpdate(userId)

            const userData = await fetchData("GET",`/users/${userId}`);

            if (userData.data.teams) {
                const teamIds = userData.data.teams.map((team: any) => team.id);
                setCheckedTeams(teamIds);
            }

            if (value?.username) {
            setUsername(value.username); 
            }
            if (value?.email) {
            setEmail(value.email); 
            }

            if (value?.role) {
            setSelectedRole(value.role); 
            }
        }

    }
    fetchUserData();
      }, [route]);

    const handleUser = async () => {
        if(isUpdate === false){
            if(username && email && checkedTeams.length > 0 && password){
                await fetchData("POST",`/users`, { username: username,email: email,team_ids: checkedTeams,role_id: selectedRole, password: password});
                navigation.goBack(); 
            }else{
                showDialog();
            }
        }else{
            if(username && email && checkedTeams.length > 0){
                await fetchData("PUT",`/users/${userIdToUpdate}`, { username: username,email: email,team_ids: checkedTeams,role_id: selectedRole});
                navigation.goBack(); 
            }else{
                showDialog();
            }
        }
    };

    const toggleTeamCheck = (teamId: number) => {
        setCheckedTeams((prevCheckedTeams) =>
            prevCheckedTeams.includes(teamId)
                ? prevCheckedTeams.filter((id) => id !== teamId) 
                : [...prevCheckedTeams, teamId] 
        );
    };

    return (
        <PaperProvider>
            <ScrollView style={styles.container}>
                <View style={styles.contentContainer}>
                    <Text style={styles.label}>Username:</Text>
                    <TextInput placeholder="Username" value={username || ''} onChangeText={(value) => setUsername(value as any)} />
                    <Text style={styles.label}>Email:</Text>
                    <TextInput placeholder="Email" value={email || ''} onChangeText={(value) => setEmail(value as any)} />
                   {isUpdate !== true && (
                      <>
                        <Text style={styles.label}>Password:</Text>
                        <TextInput placeholder="Password" value={password || ''} onChangeText={(value) => setPassword(value as any)} secureTextEntry={true} />
                      </>
                    )}
                    <Text style={styles.label}>Team:</Text>
                    {teams.length > 0 && teams.map((team) => (
                        <Checkbox.Item
                            key={team.id}
                            label={team.name}
                            status={checkedTeams.includes(team.id) ? 'checked' : 'unchecked'}
                            onPress={() => toggleTeamCheck(team.id)}
                            labelStyle={styles.label} 
                        />
                    ))}
                </View>
                <View>
                    <Text style={styles.label}>Role:</Text>
                    <RadioButton.Group 
                        onValueChange={newValue => setSelectedRole(Number(newValue))} 
                        value={selectedRole ? selectedRole.toString() : ''}
                    >
                        <View>
                            {roles
                                .filter(role => (roleId !== null && role.value < roleId))
                                .map(role => (
                                    <RadioButton.Item
                                        key={role.value}
                                        label={role.label}
                                        value={role.value.toString()}
                                         labelStyle={styles.label} 
                                    />
                                ))}
                        </View>
                    </RadioButton.Group>
                </View>

                <TouchableOpacity style={styles.addButton} onPress={handleUser}>
                    {isUpdate !== true && (
                      <>
                        <Text style={styles.buttonText}>Add</Text>
                      </>
                    )}
                    {isUpdate === true && (
                      <>
                        <Text style={styles.buttonText}>Update</Text>
                      </>
                    )}
                </TouchableOpacity>


                <Portal>
                    <Dialog visible={visible} onDismiss={hideDialog}>
                        <Dialog.Title>Champs manquants</Dialog.Title>
                        <Dialog.Content>
                        <Text style={styles.label}>Veuillez renseigner tous les champs.</Text>
                        </Dialog.Content>
                        <Dialog.Actions>
                        <Button onPress={hideDialog}>Ok</Button>
                        </Dialog.Actions>
                    </Dialog>
                </Portal>
            </ScrollView>
        </PaperProvider>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#ffffff',
        padding: 20,
    },
    contentContainer: {
        marginBottom: 20,
    },
    label: {
        marginVertical: 10,
        fontSize: 13,
        color:'black'
    },
    input: {
        backgroundColor: 'white',
        marginBottom: 15,
        padding: 10,
        borderRadius: 5,
        borderColor: '#ccc',
        borderWidth: 1,
    },
    addButton: {
        backgroundColor: '#6200ee',
        padding: 15,
        borderRadius: 5,
        alignItems: 'center',
        marginBottom: 20,
    },
    buttonText: {
        color: 'white',
        fontSize: 16,
    },
});

export default CreateUpdateUser;
