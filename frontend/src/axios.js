import axios from 'axios';
const axiosClient = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  withCredentials: true,
  withXSRFToken: true,
  
});
// axiosClient.interceptors.request.use((config => {
//     config.headers.Authorization = `Bearer ${localStorage.getItem('token')}`;
//   // You can add authorization headers or other custom headers here
//   return config;
// }, error => {
//   return Promise.reject(error);
// }));
axiosClient.interceptors.response.use(response => {
  return response;
}, error => {
  // Handle errors globally
  if(error.response && error.response.status === 401) {
    router.push({name:'login'});
  }
  throw error;
});
export default axiosClient;