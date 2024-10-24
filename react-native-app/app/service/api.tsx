import AsyncStorage from '@react-native-async-storage/async-storage';


async function extractTokens(response) {

   console.log(response);   
   // console.log(JSON.stringify(response,null,4)); //headers.map.set-cookie
    let setCookie  = response.headers.map['set-cookie']
    // console.log(setCookie);
    //access_token = chaine.split("ACCESS-TOKEN=")[1].split(";")[0]
    let refresh_token = setCookie.split("refresh_token=")[1].split(";")[0]
    // console.log(refresh_token);
    let access_token = setCookie.split("access_token=")[1].split(";")[0]
    // console.log(access_token);


    await AsyncStorage.setItem('refresh_token',refresh_token);
    await AsyncStorage.setItem('access_token',access_token);
  };


export async function fetchData(method: "GET" | "POST" | "PUT" | "DELETE",endpoint: string,body?: any): Promise<any> {
    
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
        body: method !== "GET" ? JSON.stringify(body) : null,
        credentials: "include" 
      })
  
      if(endpoint == '/login'){
         extractTokens(response)
      }


      if (!response.ok) {
        console.log("erreur");
        const errorData = await response.json()
        throw new Error(errorData.error || "An error occurred")
      }

      const json = await response.json()


      return {
        data: json,
        status: response.status
      }
    } catch (error) {
      console.error("Fetch error:", error)
      throw error
    }
  }
  