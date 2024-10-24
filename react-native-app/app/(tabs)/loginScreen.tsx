// LoginScreen.js
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { fetchData } from '../service/api';


const LoginScreen = () => {

  const navigation = useNavigation(); 

  const [username, setUsername] = useState('admin&epitech.eu');
  const [password, setPassword] = useState('password');

  const handleLogin = async () => {

    if (username && password) {
      try {
        //http://10.15.192.16:4000/api/login
        // const response = await fetch('http://127.0.0.1:4000/api/login'

        console.log("login");

        const response = await fetchData("POST",'/login', { email: username, password });

        console.log(response);
  
        


        if (response.status == "200") {
          
          const data = await response.data;
          console.log("response ok");

          await AsyncStorage.setItem('username',data.username);
          await AsyncStorage.setItem('email',data.email);
          await AsyncStorage.setItem('userId',data.id.toString());
          await AsyncStorage.setItem('roleId',data.role_id.toString());
          await AsyncStorage.setItem('teams', JSON.stringify(data.teams));

          console.log("redirect to home");
          navigation.navigate('Home'); //  Home screen

        } else {
          const errorData = await response.json();
          Alert.alert('Login Failed', errorData.message || 'Invalid credentials');
        }
      } catch (error) {
        Alert.alert('Error', 'An error occurred while logging in');
      }
    } else {
      Alert.alert('Error', 'Please enter username and password');
    }
  };

  return (
    <View style={styles.container}>
      <View style={styles.inputContainer}>
        <Text style={styles.title}>Login</Text>
        <TextInput
          style={styles.input}
          placeholder="Username"
          value={username}
          onChangeText={setUsername}
        />
        <TextInput
          style={styles.input}
          placeholder="Password"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />
      </View>
      <TouchableOpacity style={styles.button} onPress={handleLogin}>
        <Text style={styles.buttonText}>Login</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'space-between',
    padding: 16,
  },
  inputContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    marginBottom: 16,
  },
  input: {
    height: 40,
    borderColor: '#ccc',
    borderWidth: 1,
    marginBottom: 20, 
    paddingHorizontal: 8,
    width: '80%',
  },
  button: {
    backgroundColor: '#8e44ad',
    padding: 12,
    borderRadius: 5,
    alignItems: 'center',
  },
  buttonText: {
    color: '#fff',
    fontSize: 16,
  },
});

export default LoginScreen;
