import Clock from '@/components/clock';
import AsyncStorage from '@react-native-async-storage/async-storage';
import React, { useEffect, useState } from 'react';

import { View, Text, FlatList, Image, StyleSheet, TouchableOpacity } from 'react-native';
import { workingtimeModel } from './Workingtimes';
import { fetchData } from '../service/api';
import NetInfo from '@react-native-community/netinfo';
import Chart from '@/components/chart';
import { useNavigation } from '@react-navigation/native';
import Icon from 'react-native-vector-icons/FontAwesome';

const HomeTabScreen = ({ onLogout }: { onLogout: Function }) => {
  const [userId, setUserId] = useState<number>();
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [teams, setTeams] = useState([]);
  const [roleId, setRoleId] = useState<number | null>(null);
  const [role,setRole] = useState<string>('');
  const [workingTimeData, setWorkingTimeData] = useState<workingtimeModel[]>([]);
  const navigation = useNavigation();


  const roles = [
    { label: 'Employée', value: 1 },
    { label: 'Manager', value: 2 },
    { label: 'Général Manager', value: 3 },
    { label: 'Admin', value: 4 },
  ];

  const loadUserData = async () => {
    try {
      const storedUserId = await AsyncStorage.getItem('userId'); 
      const storedUsername = await AsyncStorage.getItem('username');
      const storedEmail = await AsyncStorage.getItem('email');
      const storedTeams = await AsyncStorage.getItem('teams'); 
      const storedRoleId = await AsyncStorage.getItem('roleId');

      if (storedUserId) setUserId(Number(storedUserId));
      if (storedUsername) setUsername(storedUsername);
      if (storedEmail) setEmail(storedEmail);
      if (storedTeams) setTeams(JSON.parse(storedTeams));
      if (storedRoleId) setRoleId(Number(storedRoleId));

    } catch (error) {
      console.error('Failed to load user data', error);
    }
  };

  useEffect(()=>{
      setRole(roles.find(x=>x.value==roleId)?.label as string)
  },[roleId])

  const loadWorkingTime = async () => {
    if (userId === undefined) return;

    try {
      const response = await fetchData("GET", `/workingtime/${userId}`);
      if (response) {
        const workingTimeJson = 
          typeof response.data.data === 'string' 
          ? JSON.parse(response.data.data) 
          : response.data.data;

        await AsyncStorage.setItem('workingtime', JSON.stringify(workingTimeJson));
        setWorkingTimeData(workingTimeJson);
      }

      
    } catch (error) {
      console.error('Failed to load working time data', error);
    }
  };
  
  const loadWorkingTimeFromStorage = async () => {

      const storedWorkingTime = await AsyncStorage.getItem('workingtime');
      if (storedWorkingTime) {
        setWorkingTimeData(JSON.parse(storedWorkingTime));
      }

  };

  useEffect(() => {
    loadUserData();
  }, []);


  useEffect(() => {
    const unsubscribe = NetInfo.addEventListener(state => {
      if (state.isConnected) {
        loadWorkingTime();
      } else {
        loadWorkingTimeFromStorage();
      }
    });

    return () => unsubscribe();
  }, [userId]);

  useEffect(() => {
    const unsubscribeFocus = navigation.addListener('focus', async () => {

      const unsubscribe = NetInfo.addEventListener(state => {
        if (state.isConnected) {
          loadWorkingTime();
        } else {
          loadWorkingTimeFromStorage();
        }
      });
  
      return () => unsubscribe();

    });

    return unsubscribeFocus;
  }, []);



  return (
    <View style={styles.container}>

     <TouchableOpacity style={styles.logoutButton} onPress={onLogout}>
        <Text style={styles.logoutButtonText}> <Icon name="sign-out" size={15} color="#ffffff"  /> Logout</Text>
      </TouchableOpacity>

      <View style={styles.contentContainer}>
        <View style={styles.leftColumn}>
          <Text style={styles.title}>{username}</Text>
          {teams.length > 0 ? (
            <FlatList
              data={teams}
              keyExtractor={(item) => item.id.toString()}
              renderItem={({ item }) => (
                <View style={styles.teamItem}>
                  <Text style={styles.teamName}>{item.name}</Text>
                </View>
              )}
            />
          ) : (
            <Text style={styles.noTeams}>No teams available</Text>
          )}
        </View>

        <View style={styles.rightColumn}>
          <Image

            source={{ uri: 'https://i.pinimg.com/originals/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg' }} 

            style={styles.image}
          />
            <Text style={styles.info}> {role} </Text>
        </View>
      </View>
      
      <Clock />
      <Chart workingTimes={workingTimeData}  />

    </View>
  );
};


const styles = StyleSheet.create({
  container: {
    flex: 1,

    backgroundColor: '#f3f4f6', // Light background color for a clean look
    padding: 15,

  },
  contentContainer: {
    flexDirection: 'row',
    alignItems: 'center',

    backgroundColor: '#fff', // White background for the content container
    padding: 20,
    borderRadius: 10,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.2,
    shadowRadius: 4,
    elevation: 5, // Elevation for Android shadow
    marginBottom: 15,
  },
  leftColumn: {
    flex: 0.7,
    paddingRight: 10,

  },
  rightColumn: {
    flex: 0.3,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#333',
  },

  noTeams: {
    fontSize: 16,
    color: '#888',
  },
  info: {
    fontSize: 12,
    color: '#802af8', // Updated color for emphasis
    fontWeight: 'bold',
    marginTop: 5,
    //alignSelf: 'flex-end',
  },
  teamItem: {
    marginBottom: 5,
    padding: 5,
    backgroundColor: '#bb83eb', // Light blue background for team items
    borderRadius: 5,
  },
  teamName: {
    fontSize: 12,
    color: '#ffffff',
    fontWeight: 'bold',
  },
  image: {
    width: 90,
    height: 90,
    borderRadius: 50,
   // borderWidth: 1,
    borderColor: '#b75ceb', 
  },
  logoutButton: {
    borderColor:'#e5267c',
    backgroundColor: '#ffffff', 
    padding: 5,
    borderRadius: 5,
    alignItems: 'center',
    marginTop: 5, 
    marginBottom: 20,
    marginHorizontal: 20,
  },
  logoutButton: {
    zIndex: 9999,
    position: 'absolute',
    bottom: 15,
    right: 15,
    borderWidth: 2,
    borderColor: '#ffffff',
    backgroundColor: '#ff2f75',
    paddingVertical: 4,
    paddingHorizontal: 8,
    borderRadius: 5,
    alignItems: 'center',
  },
logoutButtonText: {
    color: '#ffffff', // Set text color here
    fontSize: 14,
    fontWeight: 'bold', // Optional: makes the text more readable
  },

});


export default HomeTabScreen;

