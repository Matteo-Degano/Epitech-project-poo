import React, { useEffect, useState } from 'react';
import { DataTable } from 'react-native-paper';

import { ScrollView, TextStyle, TouchableOpacity, View, Text } from 'react-native';
import { workingtimeModel } from '@/app/(tabs)/Workingtimes';

import { useNavigation } from '@react-navigation/native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { fetchData } from '@/app/service/api';

const WorkingTimeTable = ({ workingTimeData, loadWorkingTime }: { workingTimeData: workingtimeModel[], loadWorkingTime: any }) => {

  const [page, setPage] = useState<number>(0);
  const [numberOfItemsPerPageList] = useState([10, 20]);
  const [itemsPerPage, setItemsPerPage] = useState<number>(numberOfItemsPerPageList[0]);
  const navigation = useNavigation();
  const [userId, setUserId] = useState<number | null>(null);

  const from = page * itemsPerPage;
  const to = Math.min((page + 1) * itemsPerPage, workingTimeData.length);

  const loadUserData = async () => {
    const userIdString = await AsyncStorage.getItem('userId');
    const userId = userIdString !== null ? Number(userIdString) : null;
    setUserId(userId);
  };

  useEffect(()=>{
    loadUserData();
  },[])

  useEffect(() => {
    const unsubscribe = navigation.addListener('focus', () => {
      if(userId){
        loadWorkingTime()
      }
    });

    return unsubscribe;
  }, [navigation]);


  useEffect(() => {
    setPage(0);
  }, [itemsPerPage]);


  const deleteWorkingTime = async (id: string) => {
    await fetchData("DELETE", `/workingtime/${id}`);
     loadWorkingTime();
  };
  

  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={styles.buttonAdd}
        onPress={() => navigation.navigate('WorkingTimeCreateUpdate', { isEditing:false,value:null} )}
      >
        <Text style={{ color: 'white' }}>Add Working Time</Text>
      </TouchableOpacity>

      <ScrollView horizontal>
        <DataTable style={styles.dataTable}>
          <DataTable.Header style={styles.tableHeader}>
            <DataTable.Title textStyle={styles.cellText} style={{ width: 90 }}>ID</DataTable.Title>
            <DataTable.Title textStyle={styles.cellText} style={{ flex: 2, minWidth: 200 }}>Start</DataTable.Title>
            <DataTable.Title textStyle={styles.cellText} style={{ flex: 2, minWidth: 200 }}>End</DataTable.Title>
            <DataTable.Title textStyle={styles.cellText} style={{ flex: 1, minWidth: 200 }}>Actions</DataTable.Title>
          </DataTable.Header>

          {workingTimeData.slice(from, to).map((data, index) => (
            <DataTable.Row key={data.id} style={index % 2 === 0 ? styles.evenRow : styles.oddRow}>
               <DataTable.Cell textStyle={styles.cellText}>{data.id}</DataTable.Cell>
              <DataTable.Cell textStyle={styles.cellText}>{data.start}</DataTable.Cell>
              <DataTable.Cell textStyle={styles.cellText}>{data.end}</DataTable.Cell>
              <DataTable.Cell textStyle={styles.cellText}>
                <View style={styles.buttonContainer as TextStyle}>
                  <TouchableOpacity
                    style={styles.buttonUpdate}
                    onPress={() => navigation.navigate('WorkingTimeCreateUpdate' as never,{isEditing:true,value:data})}
                  >
                    <Text style={styles.buttonText as TextStyle}>Update</Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={styles.buttonDelete}
                    onPress={() => deleteWorkingTime(data.id.toString())} 
                    >
                    <Text style={styles.buttonText as TextStyle}>Delete</Text>
                  </TouchableOpacity>
                </View>
              </DataTable.Cell>
            </DataTable.Row>
          ))}
        </DataTable>
      </ScrollView>

      <DataTable.Pagination
        style={styles.pagination}
        page={page}
        numberOfPages={Math.ceil(workingTimeData.length / itemsPerPage)}
        onPageChange={(newPage) => setPage(newPage)}
        label={`${from + 1}-${to} of ${workingTimeData.length}`}
        numberOfItemsPerPageList={[10, 20]}
        numberOfItemsPerPage={itemsPerPage}
        onItemsPerPageChange={setItemsPerPage}
        showFastPaginationControls
        selectPageDropdownLabel="Rows per page"
        backgroundColor="#7f23ff"
      />
    </View>
  );
};

const styles = {
    cell: {
    flex: 1,
    overflow: 'hidden',
    width: 200
  },
  container: {
    backgroundColor: '#ffffff',
  },
  dataTable: {
   // minWidth: 200,
  },
  tableHeader: {},
  evenRow: {
    backgroundColor: '#F5F5F5',
  },
  oddRow: {
    backgroundColor: '#FFFFFF',
  },
  cellText: {
    color: '#333333',
  },
  buttonAdd: {
    backgroundColor: '#6200ee',
    paddingVertical: 10,
    paddingHorizontal: 20,
    borderRadius: 5,
    alignSelf: 'flex-end',
    margin: 10,
  },
  buttonContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  buttonUpdate: {
    backgroundColor: '#3f9f1f',
    paddingVertical: 10,
    paddingHorizontal: 10,
    borderRadius: 5,
    marginRight: 8, 
  },
  buttonDelete: {
    backgroundColor: '#e92452',
    paddingVertical: 10,
    paddingHorizontal: 10,
    borderRadius: 5,
    fontWeight:'bold'
  },
  buttonText: {
    color: 'white',
    fontSize: 10,
    textAlign: 'center',
  },
  pagination: {
    marginBottom: 120,
  },
};

export default WorkingTimeTable;