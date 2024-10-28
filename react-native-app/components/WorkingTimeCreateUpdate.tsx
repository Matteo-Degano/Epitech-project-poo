import React, { useEffect, useState } from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import DateTimePicker from '@react-native-community/datetimepicker';
import { fetchData } from '@/app/service/api';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { useNavigation } from '@react-navigation/native';


const WorkingTimeCreateUpdate = ({route}) => {
    
    const [startDateTime, setStartDateTime] = useState(new Date());
    const [endDateTime, setEndDateTime] = useState(new Date());
    const [workingTimeId,setWorkingTimeId] = useState<number>();
    const [showStartPicker, setShowStartPicker] = useState(false);
    const [showEndPicker, setShowEndPicker] = useState(false);
    const [userId, setUserId] = useState<number | null>(null);
    const [isEditing,setIsEditing] = useState<string>('create');

    const navigation = useNavigation(); 

    const loadUserData = async () => {
        const userIdString = await AsyncStorage.getItem('userId');
        const userId = userIdString !== null ? Number(userIdString) : null;
        setUserId(userId);
      };

      useEffect(()=>{
        loadUserData();
      },[])

      useEffect(() => {
        const { isEditing, value } = route.params;
        
        setIsEditing(isEditing)

        if (value?.start) {
          setStartDateTime(new Date(value.start));
        }
        if (value?.end) {
          setEndDateTime(new Date(value.end));
        }
        if(value?.id){
            setWorkingTimeId(value.id)
        }

      }, [route]);

    const handleWorkingTime = async() => {
       if(!isEditing){
         await fetchData("POST",`/workingtime/${userId}`, { start: startDateTime,end: endDateTime});
       }else if(isEditing){
         await fetchData("PUT",`/workingtime/${workingTimeId}`, { start: startDateTime,end: endDateTime});
       }
        
        navigation.goBack(); 
    };

    const onStartDateTimeChange = (event, selectedDate) => {
        const currentDate = selectedDate || startDateTime;
        setShowStartPicker(false);
        setStartDateTime(currentDate);
    };

    const onEndDateTimeChange = (event, selectedDate) => {
        const currentDate = selectedDate || endDateTime;
        setShowEndPicker(false);
        setEndDateTime(currentDate);
    };

    return (
        <View style={styles.container}>
            <View style={styles.contentContainer}>
                <Text style={styles.label}>Start Date:</Text>
                <TouchableOpacity onPress={() => setShowStartPicker(true)} style={styles.input}>
                    <Text>{startDateTime.toISOString().slice(0, 19)}</Text>
                </TouchableOpacity>
                {showStartPicker && (
                    <DateTimePicker
                        value={startDateTime}
                        mode="datetime"
                        display="default"
                        onChange={onStartDateTimeChange}
                    />
                )}

                <Text style={styles.label}>End Date:</Text>
                <TouchableOpacity onPress={() => setShowEndPicker(true)} style={styles.input}>
                    <Text>{endDateTime.toISOString().slice(0, 19)}</Text>
                </TouchableOpacity>
                {showEndPicker && (
                    <DateTimePicker
                        value={endDateTime}
                        mode="datetime"
                        display="default"
                        onChange={onEndDateTimeChange}
                    />
                )}
            </View>

            <TouchableOpacity style={styles.addButton} onPress={handleWorkingTime}>
                <Text style={styles.buttonText}>{isEditing ? 'update' : 'create'}</Text>
            </TouchableOpacity>
        </View>
    );
};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#ffffff',
        padding: 20,
        justifyContent: 'space-between',
    },
    contentContainer: {
        marginTop:80,
        marginBottom: 20,
    },
    label: {
        marginVertical: 10,
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

export default WorkingTimeCreateUpdate;
