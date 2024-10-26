import React, { useEffect, useState } from 'react';
import { DataTable } from 'react-native-paper';
import { workingtimeModel } from '@/app/(tabs)/Workingtimes';
import { ScrollView } from 'react-native';

const WorkingTimeTable = ({ workingTimeData }: { workingTimeData: workingtimeModel[] }) => {
  const [page, setPage] = useState<number>(0);
  const [numberOfItemsPerPageList] = useState([9, 10, 15]); // Possible row counts per page
  const [itemsPerPage, setItemsPerPage] = useState<number>(numberOfItemsPerPageList[0]); // Default to the first option in the list

  const from = page * itemsPerPage;
  const to = Math.min((page + 1) * itemsPerPage, workingTimeData.length);

  useEffect(() => {
    setPage(0); // Reset to first page when `itemsPerPage` changes
  }, [itemsPerPage]);

  return (
    
    <DataTable style={styles.container}>
      <DataTable.Header style={styles.tableHeader}>
        <DataTable.Title style={styles.headerText}>ID</DataTable.Title>
        <DataTable.Title style={styles.headerText}>Start</DataTable.Title>
        <DataTable.Title style={styles.headerText}>End</DataTable.Title>
      </DataTable.Header>

      <ScrollView>
        {/* Display the paginated rows */}
        {workingTimeData.slice(from, to).map((time, index) => (
          <DataTable.Row key={time.id} style={index % 2 === 0 ? styles.evenRow : styles.oddRow}>
            <DataTable.Cell style={styles.cellText}>{time.id}</DataTable.Cell>
            <DataTable.Cell style={styles.cellText}>{time.start}</DataTable.Cell>
            <DataTable.Cell style={styles.cellText}>{time.end}</DataTable.Cell>
          </DataTable.Row>
        ))}
      </ScrollView>

      <DataTable.Pagination
        page={page}
        numberOfPages={Math.ceil(workingTimeData.length / itemsPerPage)} // Total number of pages
        onPageChange={(newPage) => setPage(newPage)} // Update page number when user clicks to change pages
        label={`${from + 1}-${to} of ${workingTimeData.length}`} // Display current range
        numberOfItemsPerPageList={numberOfItemsPerPageList} // Allow user to select number of items per page
        numberOfItemsPerPage={itemsPerPage} // Currently selected items per page
        onItemsPerPageChange={setItemsPerPage} // Update items per page when user selects a different option
        showFastPaginationControls // Enable fast navigation
        selectPageDropdownLabel="Rows per page"
      />
    </DataTable>
  );
};

const styles = {
  container: {
    padding: 15,
  },
  tableHeader: {
    //backgroundColor: '#333333', // Darker header background
  },
  headerText: {
    color: '#FFFFFF', // White text in header
  },
  evenRow: {
    backgroundColor: '#F5F5F5', // Light background for even rows
  },
  oddRow: {
    backgroundColor: '#FFFFFF', // White background for odd rows
  },
  cellText: {
    color: '#333333', // Dark text for cell content
  },
};

export default WorkingTimeTable;
