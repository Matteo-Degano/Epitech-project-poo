import React, { useEffect } from 'react';
import { View, Text, Dimensions,StyleSheet } from 'react-native';
import { LineChart } from 'react-native-chart-kit';

const Chart = ({ workingTimes }) => {

  
  useEffect(() => {
  }, [workingTimes]);

  // Create an array to hold the hours for each day of the month
  const daysInMonth = 30;
  const hoursWorked = Array(daysInMonth).fill(0); // Initialize with 0 for each day

  // Populate the hoursWorked array based on workingTimes data
  workingTimes.forEach(item => {
    const start = item.start ? new Date(item.start) : null;
    const end = item.end ? new Date(item.end) : null;

    if (start && end && !isNaN(start) && !isNaN(end) && end >= start) {
      const dayOfMonth = start.getDate() - 1; // Get the day of the month (0-based index)
      const hours = (end - start) / (1000 * 60 * 60); // Convert milliseconds to hours
      if (dayOfMonth >= 0 && dayOfMonth < daysInMonth) {
        hoursWorked[dayOfMonth] += Math.max(0, hours); // Add hours to the respective day
      }
    }
  });

  // Create x-axis labels incrementing by 5
  const labels = Array.from({ length: 7 }, (_, i) => i * 5);

  // Chart dimensions
  const screenWidth = Dimensions.get("window").width;


  return (
    <View style={chartStyles.container}>
      <Text style={chartStyles.title}>Monthly Work Hours</Text>
      <LineChart
        data={{
          labels, // Use the incremented labels
          datasets: [
            {
              data: hoursWorked.slice(0, 31), // Take only the first 31 days of data
              color: (opacity = 1) => `rgba(0, 0, 255, ${opacity})`,
              strokeWidth: 2,
            },
          ],
        }}
        width={screenWidth - 30} // Adjust width to fit within the container
        height={220}
        yAxisSuffix="h"
        chartConfig={{
          backgroundGradientFrom: "#fff",
          backgroundGradientTo: "#fff",
          decimalPlaces: 1,
          color: (opacity = 1) => `rgba(0, 0, 0, ${opacity})`,
          labelColor: (opacity = 1) => `rgba(0, 0, 0, ${opacity})`,
          style: {
            borderRadius: 16,
          },
          propsForDots: {
            r: "0", // Remove dots
          },
        }}
        bezier
        style={{
          marginVertical: 0,
          borderRadius: 16,
          overflow: 'hidden', // Ensure chart is contained
        }}
      />
    </View>
  );
};

const chartStyles = StyleSheet.create({
  container: {
    paddingHorizontal: 15, // Adjust horizontal padding to provide some space
    paddingVertical: 10, // Add some vertical padding
    backgroundColor: '#fff',
    borderRadius: 10,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.2,
    shadowRadius: 4,
    elevation: 5,
    marginVertical: 10,
  },
  title: {
    textAlign: 'center',
    fontSize: 13,
    fontWeight: 'bold',
    marginVertical: 12,
    color: '#840ca8',
  },
});

export default Chart;