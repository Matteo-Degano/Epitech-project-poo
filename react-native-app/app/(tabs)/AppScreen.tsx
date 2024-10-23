
import AsyncStorage from '@react-native-async-storage/async-storage';
import React, { useEffect, useState } from 'react';
import { View, Text, FlatList, Image, StyleSheet } from 'react-native'; // Correct import for Image
// import ClockManager from './clockManager';


const AppScreen = () => {


  const [username, setUsername] = useState('');
  const [email,setEmail] = useState('')
  const [teams, setTeams] = useState([]);

  //Array(1)0: {id: 1, name: 'Developpeur Front-end'}


  const loadUserData = async () => {
    try {

      const storedUsername = await AsyncStorage.getItem('username');
      const storedEmail = await AsyncStorage.getItem('email');
      const storedTeams = await AsyncStorage.getItem('teams'); 

      if (storedUsername) {
        setUsername(storedUsername);
      }

      if(storedEmail){
        setEmail(storedEmail)
      }

      //  const storedTeams = await AsyncStorage.getItem('teams');
      
      if (storedTeams) {
        setTeams(JSON.parse(storedTeams)); // Parse the JSON string back to an array
      }

    } catch (error) {
      console.error('Failed to load user data', error);
    }
  };

  useEffect(() => {
    loadUserData(); 
  }, []);
  
    return (
      <View style={styles.container}>
      <View style={styles.contentContainer}>
        <View style={styles.leftColumn}>
          <Text style={styles.title}>{username}</Text>
          <Text style={styles.title}>{email}</Text>
          <Text style={styles.title}>Teams</Text>
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
            <Text>No teams available</Text>
          )}
        </View>
        
        {/* Colonne droite avec une image */}
        <View style={styles.rightColumn}>
          <Image
            source={{ uri: 'https://www.cambridge.org/elt/blog/wp-content/uploads/2019/07/Dog-Emoji.png' }} // URL de l'image
            style={styles.image}
          />
        </View>
      </View>

      {/* <View>
        <ClockManager/>
      </View> */}

    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    // justifyContent: 'center',
    // alignItems: 'center',
    backgroundColor: '#e0f7e0', // Arrière-plan vert clair
  },
  contentContainer: {
    flexDirection: 'row', // Affiche en ligne les éléments (gauche/droite)
    alignItems: 'center',
    backgroundColor: '#98fb98', // Vert plus foncé pour le conteneur
    padding: 20,
    borderRadius: 10,
  },
  leftColumn: {
    flex: 1, // Colonne gauche occupe 1 part d'espace
  },
  rightColumn: {
    flex: 0.3, // Colonne droite pour l'image (réduite)
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 10,
    color: '#333',
  },
  teamItem: {
    marginBottom: 5,
  },
  teamName: {
    fontSize: 16,
    color: '#555',
  },
  image: {
    width: 100,
    height: 100,
    borderRadius: 50,
  },
});

  
export default AppScreen;