export function formatDateTime(datetimeString: string | number | Date): string {
  const date = new Date(datetimeString)

  const options: Intl.DateTimeFormatOptions = {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false
  }

  return date.toLocaleString(undefined, options)
}
