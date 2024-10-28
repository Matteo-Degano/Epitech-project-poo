import { StyleSheet, View,LogBox } from 'react-native';
import React, { useState, useEffect } from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { Snackbar } from 'react-native-paper';
import NetInfo from '@react-native-community/netinfo';
import LoginScreen from './loginScreen';
import HomeTabScreen from './HomeTabScreen';
import Users from './Users';
import CreateUpdateUser from '@/components/CreateUpdateUser';
import Workingtimes from './Workingtimes';
import WorkingTimeCreateUpdate from '@/components/WorkingTimeCreateUpdate';
import Icon from 'react-native-vector-icons/FontAwesome';
import AsyncStorage from '@react-native-async-storage/async-storage';

const Stack = createStackNavigator();
const Tab = createBottomTabNavigator();

function UsersStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen name="Users" component={Users} options={{ headerShown: false }} />
      <Stack.Screen
        name="CreateUpdateUser"
        component={CreateUpdateUser}
        options={({ route }) => ({
          title: (route.params as { isEditing?: boolean })?.isEditing ? 'Edit an user' : 'Create an user',
        })}
      />
    </Stack.Navigator>
  );
}

function WorkingtimesStack() {
  return (
    <Stack.Navigator>
      <Stack.Screen name="Workingtimes" component={Workingtimes} options={{ headerShown: false }} />
      <Stack.Screen name="WorkingTimeCreateUpdate" component={WorkingTimeCreateUpdate} 
        options={({ route }) => ({
          title: (route.params as { isEditing?: boolean })?.isEditing ? 'Edit a working time' : 'Create a working time',
        })}
      />
    </Stack.Navigator>
  );
}

function TabNavigator({ onLogout, roleId }: { onLogout: Function; roleId: number }) {
  return (
    <Tab.Navigator
      screenOptions={{
        tabBarStyle: {
          backgroundColor: '#ffffff', 
        },
        tabBarActiveTintColor: '#8e44ad',
        tabBarInactiveTintColor: '#dcdcdc', 
      }}
    >
      <Tab.Screen 
        name="Home" 
        children={() => <HomeTabScreen onLogout={onLogout} />}
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name="home" color={color} size={size} />
          ),
        }}
      />
      {roleId > 1 && (
      <Tab.Screen name="Working Time" component={WorkingtimesStack} 
        options={{
            tabBarIcon: ({ color, size }) => (
              <Icon name="clock-o" color={color} size={size} />
            ),
        }}
      />
      )}
      {roleId > 1 && (
      <Tab.Screen name="Users" component={UsersStack} 
        options={{
          tabBarIcon: ({ color, size }) => (
            <Icon name="users" color={color} size={size} />
          ),
        }}
      />
      )}
    </Tab.Navigator>
  );
}

export default function App() {
  const [isSignedIn, setIsSignedIn] = useState(false);
  const [roleId, setRoleId] = useState<number | null>(null);
  const [isOffline, setIsOffline] = useState(false);
  const [snackbarVisible, setSnackbarVisible] = useState(false);

  useEffect(() => {
    const checkUserRole = async () => {
      const storedRoleId = await AsyncStorage.getItem('roleId');
      if (storedRoleId) {
        setRoleId(parseInt(storedRoleId, 10)); 
      }
    };
    
    checkUserRole();
  }, []);

  useEffect(() => {
    
    LogBox.ignoreAllLogs(true);

    const unsubscribe = NetInfo.addEventListener(state => {
      if (!state.isConnected) {
        setIsOffline(true);
        setSnackbarVisible(true);  // Show Snackbar when offline
      } else {
        setIsOffline(false);
        setSnackbarVisible(false); // Hide Snackbar when back online
      }
    });

    return () => unsubscribe();  // Clean up the listener on unmount
  }, []);

  const handleLogin = (role: number) => {
    setIsSignedIn(true);
    setRoleId(role);
  };

  const handleLogout = async () => {
    setIsSignedIn(false);
    await AsyncStorage.removeItem('roleId');
  };

  return (
    <NavigationContainer independent={true}>
      <View style={styles.container}>
        <Stack.Navigator initialRouteName="Login">
          {!isSignedIn ? (
            <Stack.Screen 
              name="Login" 
              options={{ headerShown: false }} 
            >
              {() => <LoginScreen onLogin={handleLogin} />} 
            </Stack.Screen>
          ) : (
            <Stack.Screen name="Home" options={{ headerShown: false }}>
              {() => <TabNavigator onLogout={handleLogout} roleId={roleId || 0} />}
            </Stack.Screen>
          )}
        </Stack.Navigator>
        <Snackbar
          visible={snackbarVisible}
          onDismiss={() => setSnackbarVisible(false)}
          action={{
            label: 'Close',
            onPress: () => setSnackbarVisible(false),
          }}
        >
          You are offline. Some features may not be available.
        </Snackbar>
      </View>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
});
