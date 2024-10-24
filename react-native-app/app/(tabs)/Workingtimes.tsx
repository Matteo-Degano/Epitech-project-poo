
import AsyncStorage from '@react-native-async-storage/async-storage';
import React, { useEffect, useState } from 'react';
import { View, Text, TextInput, Button, FlatList, StyleSheet } from 'react-native';
import { fetchData } from '../service/api';
import WorkingTimeTable from '@/components/WorkingTimeTable';
import { PaperProvider } from 'react-native-paper';



export interface workingtimeModel {
    id: number
    start:string 
    end:string 
    user_id: number
}

const Workingtimes = ()=>{

    const [data, setData] = useState([]);
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState(null);
    const [start, setStart] = useState('');
    const [end, setEnd] = useState('');
    const [page, setPage] = useState(1);
    const [limit] = useState(10); 
    const [userId,setUserId] = useState<number>()
    const [workingTimeData,setWorkingTimeData] = useState<workingtimeModel[]>([]);


    const getUserId = async ()=>{
        
        const storedUserId = await AsyncStorage.getItem('userId'); 

        if(storedUserId){
            console.log(storedUserId);
          setUserId(Number(storedUserId))
        }
    }

    const LoadWorkingTime = async ()=>{
        const response = await fetchData("GET",`/workingtime/${userId}`);
        console.log(response);

        if(response){
            //console.log(response.data.data);
            setWorkingTimeData(response.data)
        }
    }

    useEffect(() => {
        getUserId()
      }, []);

    useEffect(()=>{
       
        console.log("userId");
        if(userId){
           LoadWorkingTime();
        }

    },[userId])

    useEffect(()=>{
        console.log("-----------------");
        console.log(workingTimeData);
    },[workingTimeData])
  
      

    return (
       
        <View>
            {workingTimeData.length > 0 && <WorkingTimeTable  workingTimeData={workingTimeData} />}
        </View>
    //      <PaperProvider></PaperProvider>
      )
}


export default Workingtimes;