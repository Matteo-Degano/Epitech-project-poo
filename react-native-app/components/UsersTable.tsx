import React, { useEffect, useState } from 'react';
import { DataTable } from 'react-native-paper';
import { usersModel } from '@/app/(tabs)/Users';
import { ScrollView, TextStyle, View, TouchableOpacity, Text } from 'react-native';
import { useNavigation } from '@react-navigation/native';
import { fetchData } from '@/app/service/api';
import { withDecay } from 'react-native-reanimated';

const UsersTable = ({ usersData, LoadUsers }: { usersData: usersModel[], LoadUsers: any }) => {
  const [page, setPage] = useState<number>(0);
  const [numberOfItemsPerPageList] = useState([9, 10, 15]);
  const [itemsPerPage, setItemsPerPage] = useState<number>(numberOfItemsPerPageList[0]);
  const navigation = useNavigation();

  const from = page * itemsPerPage;
  const to = Math.min((page + 1) * itemsPerPage, usersData.length);

  const deleteUser = async (id: string) => {
    const idNumber = Number(id);
    try {
      await fetchData("DELETE", `/users/${idNumber}`);
    } catch (error) {
      console.log(error);
    }
    LoadUsers();
  };

  useEffect(() => {
    setPage(0);
  }, [itemsPerPage]);

  useEffect(() => {
    const unsubscribe = navigation.addListener('focus', () => {
      LoadUsers()
    });

    return unsubscribe;
  }, [navigation]);

  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={styles.buttonAdd}
        onPress={() => navigation.navigate('CreateUpdateUser', { isEditing: false, value: null })}
      >
        <Text style={{ color: 'white' }}>Add User</Text>
      </TouchableOpacity>

      <ScrollView horizontal>
        <DataTable style={styles.dataTable}>
          <DataTable.Header style={styles.tableHeader}>
            <DataTable.Title textStyle={styles.cellText} style={{ width: 35 }}>ID</DataTable.Title>
            <DataTable.Title textStyle={styles.cellText} style={{ flex: 2, minWidth: 200 }}>Username</DataTable.Title>
            <DataTable.Title textStyle={styles.cellText} style={{ flex: 2, minWidth: 200 }}>Email</DataTable.Title>
            <DataTable.Title textStyle={styles.cellText} style={{ flex: 1, minWidth: 200 }}>Actions</DataTable.Title>
          </DataTable.Header>

          {usersData.slice(from, to).map((data, index) => (
            <DataTable.Row key={data.id} style={index % 2 === 0 ? styles.evenRow : styles.oddRow}>
              <DataTable.Cell textStyle={styles.cellText} style={{ width: 20 }}>{data.id}</DataTable.Cell>
              <DataTable.Cell textStyle={styles.cellText} style={styles.cell}>{data.username}</DataTable.Cell>
              <DataTable.Cell textStyle={styles.cellText} style={styles.cell}>{data.email}</DataTable.Cell>
              <DataTable.Cell textStyle={styles.cellText} style={styles.cell}>
                <View style={styles.buttonContainer as TextStyle}>
                  <TouchableOpacity
                    style={styles.buttonUpdate}
                    onPress={() => navigation.navigate('CreateUpdateUser' as never, { isEditing: true, value: data })}
                  >
                    <Text style={styles.buttonText as TextStyle}>Update</Text>
                  </TouchableOpacity>
                  <TouchableOpacity
                    style={styles.buttonDelete}
                    onPress={() => deleteUser(data.id.toString())}
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
    numberOfPages={Math.ceil(usersData.length / itemsPerPage)}
    onPageChange={(newPage) => setPage(newPage)}
    label={`${from + 1}-${to} of ${usersData.length}`}
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
    width: 200,
  },
  container: {
    backgroundColor: '#ffffff',
  },
  dataTable: {
    minWidth: 800,
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
    fontWeight: 'bold'
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

export default UsersTable;