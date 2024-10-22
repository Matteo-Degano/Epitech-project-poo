// LoginScreen.js
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, StyleSheet, Alert } from 'react-native';

const LoginScreen = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const handleLogin = () => {
    // Handle login logic here (e.g., API call)
    Alert.alert('Login Pressed', `Username: ${username}, Password: ${password}`);
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
    justifyContent: 'space-between', // Space out input fields and button
    padding: 16,
  },
  inputContainer: {
    flex: 1,
    justifyContent: 'center', // Center inputs vertically
    alignItems: 'center', // Center inputs horizontally
  },
  title: {
    fontSize: 24,
    marginBottom: 16, // Reduced margin for title
  },
  input: {
    height: 40,
    borderColor: '#ccc',
    borderWidth: 1,
    marginBottom: 0, // No space between inputs
    paddingHorizontal: 8,
    width: '80%', // Centering input width
    marginTop:20
  },
  button: {
    backgroundColor: '#8e44ad', // Purple color
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
