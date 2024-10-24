
import AsyncStorage from '@react-native-async-storage/async-storage';
import React, { useEffect, useState } from 'react';
import { View, Text, TextInput, Button, FlatList, StyleSheet } from 'react-native';
import { fetchData } from '../service/api';



interface workingtimeModel {
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
            console.log(response.data);
        }
    }

    useEffect(() => {
        getUserId()
      }, []);

    useEffect(()=>{
       
        LoadWorkingTime();

    },[userId])
  
      

    return (
        <Text>
            Workingtimes
        </Text>
    )
}


export default Workingtimes;