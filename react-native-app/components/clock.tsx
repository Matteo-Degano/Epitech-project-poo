import AsyncStorage from '@react-native-async-storage/async-storage';
import React, { useState, useEffect } from 'react';
import { View, Text, Button, StyleSheet, Alert } from 'react-native';
import { fetchData } from '../app/service/api';

// Helper function to format time (HH:MM:SS)
function formatTime(elapsedTime) {
  const hours = Math.floor(elapsedTime / (1000 * 60 * 60));
  const minutes = Math.floor((elapsedTime % (1000 * 60 * 60)) / (1000 * 60));
  const seconds = Math.floor((elapsedTime % (1000 * 60)) / 1000);
  return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`;
}

function frenchDate() {
  const currentDate = new Date()
  const offset = currentDate.getTimezoneOffset() * 60000
  const parisTime = new Date(currentDate.getTime() - offset)
  return parisTime.toISOString()
}

const Clock = () => {  
  const [userId, setUserId] = useState<number | null>(null);
  const [time, setTime] = useState("00:00:00");
  const [isClockRunning, setIsClockRunning] = useState(false);
  const [pausedTime, setPausedTime] = useState(0);
  const [intervalId, setIntervalId] = useState<NodeJS.Timeout | null>(null);

  // Function to start the clock
  const startClock = async () => {
    setIsClockRunning(true);
    const startDateTime = new Date().getTime() - pausedTime;

    // API call with dynamic userId
    await fetchData('POST', `/clocks/${userId}`, { time: frenchDate(), status: true });

    const id = setInterval(() => {
      const elapsedTime = new Date().getTime() - startDateTime;
      setTime(formatTime(elapsedTime));
    }, 1000);
    setIntervalId(id);
  };

  // Function to stop the clock
  const stopClock = async () => {
    setIsClockRunning(false);
    if (intervalId) {
      clearInterval(intervalId);
      setIntervalId(null);
    }
    setTime("00:00:00");
    setPausedTime(0);

    await fetchData('POST', `/clocks/${userId}`, { time: frenchDate(), status: false });
  };

  // Function to handle the clock-out confirmation
  const handleStopClock = () => {
    Alert.alert('Clock Out', 'Are you sure you want to clock out?', [
      { text: 'Cancel', style: 'cancel' },
      { text: 'Yes', onPress: stopClock },
    ]);
  };

  // Function to load user data from AsyncStorage
  const loadUserData = async () => {
    const userIdString = await AsyncStorage.getItem('userId');
    const userId = userIdString !== null ? Number(userIdString) : null;
    setUserId(userId);
  };

  // Function to get the clock's current state
  const getClock = async () => {
    if (userId === null) return; // Prevent API call if userId is null
    try {
      const response = await fetchData('GET', `/clocks/${userId}`);
      if (response.data && Array.isArray(response.data.data) && response.data.data.length > 0) {
        const sortedClocks = response.data.data.sort((a, b) => 
          new Date(b.time).getTime() - new Date(a.time).getTime()
        );

        const lastClock = sortedClocks[0];
        if (lastClock.status === true) {
          setIsClockRunning(true);
          const clockStartTime = new Date(lastClock.time).getTime();
          const elapsedTime = new Date().getTime() - clockStartTime;
          setPausedTime(elapsedTime);
          setTime(formatTime(elapsedTime));

          const id = setInterval(() => {
            const newElapsedTime = new Date().getTime() - clockStartTime;
            setTime(formatTime(newElapsedTime));
          }, 1000);
          setIntervalId(id);
        }
      }
    } catch (error) {
      console.error('Error fetching clocks:', error);
    }
  };

  // Load user data and clock state on component mount
  useEffect(() => {
    loadUserData().then(() => {
      if (userId) {
        getClock(); // Call getClock only if userId is valid
      }
    });

    return () => {
      if (intervalId) {
        clearInterval(intervalId); // Clean up on unmount
      }
    };
  }, [userId]); // Only depend on userId

  return (
    <View style={styles.container}>
      {!isClockRunning ? (
        <Button style={styles.button} title={time} onPress={startClock} />
      ) : (
        <Button title={time} onPress={handleStopClock} color="green" />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f0f8ff',   
  },
});

export default Clock;
