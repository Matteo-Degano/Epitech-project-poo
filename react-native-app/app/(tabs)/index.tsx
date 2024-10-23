import { Image, StyleSheet, Platform, View } from 'react-native';

import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';


import LoginScreen from './loginScreen';
import AppScreen from './AppScreen';


const Stack = createStackNavigator();

export default function HomeScreen() {
  return (

    <NavigationContainer independent={true}>
    <Stack.Navigator initialRouteName="Login">
      <Stack.Screen name="Login" component={LoginScreen} />
      <Stack.Screen name="Home" component={AppScreen} />
    </Stack.Navigator>
  </NavigationContainer>
  //   <View style={styles.container}>
  //   <LoginScreen />
  // </View>

  );
}


const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});


// const styles = StyleSheet.create({
//   titleContainer: {
//     flexDirection: 'row',
//     alignItems: 'center',
//     gap: 8,
//   },
//   stepContainer: {
//     gap: 8,
//     marginBottom: 8,
//   },
//   reactLogo: {
//     height: 178,
//     width: 290,
//     bottom: 0,
//     left: 0,
//     position: 'absolute',
//   },
// });
