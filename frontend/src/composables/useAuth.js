import { ref } from 'vue'

const isLoggedIn = ref(!!cookieStore.get('laravel-session'))

function login() {
  // localStorage.setItem('userLogged', '1')
  isLoggedIn.value = true
}

function logout() {
  cookieStore.delete('laravel-session')
  isLoggedIn.value = false
}

export function useAuth() {
  return {
    isLoggedIn,
    login,
    logout,
  }
}
