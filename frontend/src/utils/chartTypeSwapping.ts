export const chartTypeSwapping = (chartType: string) => {
  switch (chartType) {
    case "line":
      return "bar"
    case "bar":
      return "line"
    default:
      return "line"
  }
}
