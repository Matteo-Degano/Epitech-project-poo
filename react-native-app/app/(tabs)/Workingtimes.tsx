
import AsyncStorage from '@react-native-async-storage/async-storage';
import React, { useEffect, useState } from 'react';
import { View, StyleSheet, ScrollView } from 'react-native';
import { fetchData } from '../service/api';
import WorkingTimeTable from '@/components/WorkingTimeTable';
import { PaperProvider } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';

export interface workingtimeModel {
    id: number
    start:string 
    end:string 
    user_id: number
}

const Workingtimes = ()=>{

    const [userId,setUserId] = useState<number>()
    const [workingTimeData,setWorkingTimeData] = useState<workingtimeModel[]>([]);
    const navigation = useNavigation();

    const getUserId = async ()=>{
        
        const storedUserId = await AsyncStorage.getItem('userId'); 

        if(storedUserId){
          setUserId(Number(storedUserId))
        }
    }


    const LoadWorkingTime = async () => {

      try {
        const response = await fetchData("GET", `/workingtime/${userId}`);
        try {
          setWorkingTimeData(response.data.data);
        } catch (jsonError) {
          console.error("JSON Parsing Error:", jsonError);

        }
      } catch (error) {
        console.error("Error fetching working time:", error);
      }
    };

    useEffect(() => {
        getUserId()
      }, []);

    useEffect(()=>{

       
        if(userId){
           LoadWorkingTime();
        }

    },[userId])

    useEffect(() => {
      const unsubscribe = navigation.addListener('focus', () => {
        if(userId){
          LoadWorkingTime()
        }
      });
  
      return unsubscribe;
    }, [navigation]);

    return (
        <PaperProvider>
            <ScrollView contentContainerStyle={styles.scrollContainer}>
                <View style={styles.container}>
                    {workingTimeData && <WorkingTimeTable workingTimeData={workingTimeData} loadWorkingTime={LoadWorkingTime} />}
                </View>
            </ScrollView>
        </PaperProvider>
      )
}


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
    },
  });


export default Workingtimes;