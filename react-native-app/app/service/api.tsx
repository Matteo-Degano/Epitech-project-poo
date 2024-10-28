import AsyncStorage from '@react-native-async-storage/async-storage';


async function extractTokens(response: Response) {
 
   const setCookie = response.headers.get('set-cookie');
   if (setCookie) {
      const refresh_token = setCookie.split("refresh_token=")[1].split(";")[0];
      const access_token = setCookie.split("access_token=")[1].split(";")[0];

      await AsyncStorage.setItem('refresh_token', refresh_token);
      await AsyncStorage.setItem('access_token', access_token);
   }
};


export async function fetchData(method: "GET" | "POST" | "PUT" | "DELETE", endpoint: string,body?: any): Promise<any> {
    
    try {
        let access_token:string | null = null;
        let headers: HeadersInit | null = null;

        if(endpoint != '/login'){
           const refresh_token = await AsyncStorage.getItem('refresh_token');
           access_token = await AsyncStorage.getItem('access_token');

           headers = {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${access_token}`,
          }

        }else{
            await AsyncStorage.removeItem('refresh_token');
            await AsyncStorage.removeItem('access_token');

            headers = {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              }
        }

      const response = await fetch(`http://10.15.192.16:4000/api${endpoint}`, {
            method,
            headers,
            body: method !== "GET" && method !== "DELETE" ? JSON.stringify(body) : null,
            credentials: "include" 
          })

  
      if(endpoint == '/login'){
           extractTokens(response)
        }


      if (!response.ok) {
            const errorData = await response.text(); 
            throw new Error(errorData || "An error occurred");
        }

        let json: any;
        const contentType = response.headers.get('content-type');
        if (contentType && contentType.includes('application/json')) {
            json = await response.json();
        } else {
            json = {}; 
        }

        return {
          data: json,
          status: response.status
        }
    } catch (error) {
      console.error("Fetch error:", error)
      throw error
    }
  }
  