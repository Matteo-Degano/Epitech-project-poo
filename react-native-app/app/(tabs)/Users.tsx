import AsyncStorage from '@react-native-async-storage/async-storage';
import React, { useEffect, useState } from 'react';
import { View, StyleSheet, Text, TouchableOpacity } from 'react-native';
import { fetchData } from '../service/api';
import UsersTable from '@/components/UsersTable';
import { PaperProvider } from 'react-native-paper';
import { ScrollView } from 'react-native-gesture-handler';

export interface usersModel {
    id: number;
    email: string; 
    username: string; 
    team_id: number;
}

const Users = () => {
    const [userId, setUserId] = useState<number>();
    const [usersData, setUsersData] = useState<usersModel[]>([]);

    const getUserId = async () => {
        const storedUserId = await AsyncStorage.getItem('userId'); 
        if (storedUserId) {
            setUserId(Number(storedUserId));
        }
    };

    const LoadUsers = async () => {
        const response = await fetchData("GET", `/users`);
        if (response) {
            setUsersData(response.data.data);
        }
    };

    useEffect(() => {
        getUserId();
    }, []);

    useEffect(() => {
        if (userId) {
            LoadUsers();
        }
    }, [userId]);

    return (
        <PaperProvider>
            <ScrollView 
                contentContainerStyle={styles.scrollContainer} // Correction ici
            >
                <View style={styles.container}>
                  {usersData.length > 0 && <UsersTable usersData={usersData} LoadUsers={LoadUsers} />}
                </View>
            </ScrollView>
        </PaperProvider>
    );
};

const styles = StyleSheet.create({
    container: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
      padding: 10, 
    },
    scrollContainer: {
      flexGrow: 1, 
      paddingBottom: 20,
    }
});

export default Users;
