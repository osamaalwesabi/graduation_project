<template>
  <header
    class="fixed top-0 left-0 right-0 z-40
           bg-white dark:bg-[#0f172a]
           border-b border-gray-100 dark:border-slate-700"
  >
    <nav class="mx-auto max-w-[1380px] px-4 h-20 flex items-center justify-between gap-6">
      <!-- الشعار -->
      <RouterLink
        to="/"
        class="flex items-center gap-2 shrink-0 select-none cursor-pointer"
      >
        <img src="@/assets/logo.png" alt="شعار الهيئة" class="h-[60px] w-auto" />
      </RouterLink>

      <!-- روابط الديسكتوب -->
      <ul
        v-if="!loading"
        class="hidden lg:flex items-center gap-4 font-medium text-[16px]"
        :style="{ color: headColor }"
      >
        <!-- عرض جميع الصفحات -->
        <template v-for="page in pages" :key="page.id">
          <!-- إذا كانت الصفحة لديها محتويات فرعية -->
          <li v-if="page.contents && page.contents.length > 0 && page.has_children === 0" class="relative whitespace-nowrap flex items-center">
            <button
              class="nav-link cursor-pointer hover:opacity-80 flex items-center gap-1"
              @click.stop="toggle(page.slug)"
            >
              <span>{{ page.name }}</span>
              <svg
                class="w-4 h-4 transition-transform"
                :class="{ 'rotate-180': openMenu === page.slug }"
                viewBox="0 0 20 20"
                fill="currentColor"
              >
                <path
                  d="M5.23 7.21a.75.75 0 0 1 1.06.02L10 10.94l3.71-3.71a.75.75 0 1 1 1.06 1.06l-4.24 4.24a.75.75 0 0 1-1.06 0L5.21 8.29a.75.75 0 0 1 .02-1.08z"
                />
              </svg>
            </button>

            <transition name="fade">
              <div
                v-if="openMenu === page.slug"
                :ref="el => setMenuRef(page.slug, el)"
                class="absolute right-0 top-full mt-3 w-56 rounded-xl border border-gray-100 dark:border-slate-700 bg-white dark:bg-slate-900 shadow-lg p-2"
              >
                <RouterLink 
                  v-for="content in page.contents" 
                  :key="content.id"
                  class="dd-item" 
                  :style="{ color: headColor }" 
                  :to="getContentRoute(page, content)"
                  @click="openMenu = null"
                >
                  {{ content.slug }}
                </RouterLink>
              </div>
            </transition>
          </li>
          
          <!-- إذا كانت الصفحة بدون محتويات فرعية -->
          <li v-else class="relative whitespace-nowrap flex items-center">
            <RouterLink 
              class="nav-link hover:opacity-80" 
              :to="getPageRoute(page)"
            >
              {{ page.name }}
            </RouterLink>
          </li>
        </template>
      </ul>

      <!-- عرض حالة التحميل -->
      <div v-else class="hidden lg:flex items-center gap-4">
        <div class="h-6 w-24 bg-gray-200 dark:bg-gray-700 rounded animate-pulse"></div>
        <div class="h-6 w-20 bg-gray-200 dark:bg-gray-700 rounded animate-pulse"></div>
        <div class="h-6 w-28 bg-gray-200 dark:bg-gray-700 rounded animate-pulse"></div>
      </div>

      <!-- أزرار يسار -->
      <div class="flex items-center gap-2">
        <!-- زر سجّل مشروعك -->
        <button
          @click="goToRegisterProjectForm"
          class="hidden md:inline-block px-3.5 py-1.5 rounded-xl text-white whitespace-nowrap"
          :style="{ backgroundColor: linkColor }"
        >
          سجّل مشروعك
        </button>

        <!-- زر الدارك مود -->
        <button
          class="inline-flex items-center justify-center w-9 h-9 rounded-xl border bg-white dark:bg-[#020617] dark:border-slate-600 dark:text-slate-100"
          :style="{ borderColor: linkColor, color: linkColor }"
          @click="toggleDark"
        >
          <svg v-if="!isDark" class="w-5 h-5" viewBox="0 0 24 24" fill="none">
            <path
              stroke="currentColor"
              stroke-width="1.8"
              d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79Z"
            />
          </svg>
          <svg v-else class="w-5 h-5" viewBox="0 0 24 24" fill="none">
            <path
              d="M12 18a6 6 0 1 0 0-12 6 6 0 0 0 0 12Z"
              stroke="currentColor"
              stroke-width="1.8"
            />
            <path
              d="M12 2v2.5M12 19.5V22M4.22 4.22 5.8 5.8M18.2 18.2l1.58 1.58M2 12h2.5M19.5 12H22M4.22 19.78 5.8 18.2M18.2 5.8 19.78 4.22"
              stroke="currentColor"
              stroke-width="1.8"
            />
          </svg>
        </button>

        <!-- زر الحساب -->
        <RouterLink
          :to="isLoggedIn ? '/profile' : '/login'"
          class="inline-flex items-center justify-center w-9 h-9 rounded-xl border bg-white dark:bg-slate-900 dark:border-slate-600 dark:text-slate-100"
          :style="{ borderColor: linkColor, color: linkColor }"
        >
          <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none">
            <path stroke="currentColor" stroke-width="1.8" d="M12 12a4 4 0 1 0 0-8 4 4 0 0 0 0 8Zm7 8a7 7 0 1 0-14 0"/>
          </svg>
        </RouterLink>

        <!-- زر منيو الموبايل -->
        <button
          class="lg:hidden inline-flex items-center justify-center w-9 h-9 rounded-xl border bg-white dark:bg-slate-900 dark:border-slate-600 dark:text-slate-100"
          :style="{ borderColor: linkColor, color: linkColor }"
          @click="mobileOpen = !mobileOpen"
        >
          <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none">
            <path stroke="currentColor" stroke-width="1.8" d="M4 6h16M4 12h16M4 18h16"/>
          </svg>
        </button>
      </div>
    </nav>

    <!-- منيو الموبايل -->
    <transition name="fade">
      <div
        v-if="mobileOpen && !loading"
        class="lg:hidden fixed inset-0 z-50 flex justify-start
               bg-white/60 dark:bg-[#0f172a]/70 backdrop-blur-sm"
      >
        <div
          class="relative w-[78%] max-w-xs h-full bg-white/90 dark:bg-[#0f172a]/95
                 border-r border-slate-100 dark:border-slate-700
                 pt-6 pb-8 px-4 space-y-4"
          :style="{ color: headColor }"
          dir="rtl"
        >
          <!-- الشعار في أعلى المنيو -->
          <div class="flex items-center justify-between mb-6">
            <img src="@/assets/logo.png" alt="شعار الهيئة" class="h-10 w-auto" />

            <button
              class="w-8 h-8 flex items-center justify-center rounded-full
                     border border-slate-200 dark:border-slate-600 text-slate-500"
              @click="mobileOpen = false"
            >
              ✕
            </button>
          </div>

          <!-- الروابط الديناميكية -->
          <div class="space-y-2 text-[16px]">
            <template v-for="page in pages" :key="page.id">
              <!-- إذا كانت الصفحة لديها محتويات فرعية -->
              <details v-if="page.contents && page.contents.length > 0 && page.has_children === 0" class="mobile-item">
                <summary @click="toggleMobileMenu(page.slug)">
                  <span>{{ page.name }}</span>
                  <span class="circle-arrow">
                    <span class="chevron"></span>
                  </span>
                </summary>
                <div class="children">
                  <RouterLink 
                    v-for="content in page.contents" 
                    :key="content.id"
                    class="block py-1" 
                    :to="getContentRoute(page, content)" 
                    @click="mobileOpen = false"
                  >
                    {{ content.slug }}
                  </RouterLink>
                </div>
              </details>
              
              <!-- إذا كانت الصفحة بدون محتويات فرعية -->
              <RouterLink 
                v-else 
                class="mobile-link" 
                :to="getPageRoute(page)" 
                @click="mobileOpen = false"
              >
                {{ page.name }}
              </RouterLink>
            </template>
          </div>
        </div>
      </div>
    </transition>
  </header>
</template>

<script setup>
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { RouterLink, useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'

const router = useRouter()
const { isLoggedIn } = useAuth()

const isDark = ref(false)
const headColor = computed(() => (isDark.value ? '#E5F4F7' : '#185974'))
const linkColor = computed(() => (isDark.value ? '#38BDF8' : '#27AEB9'))

const openMenu = ref(null)
const mobileOpen = ref(false)
const loading = ref(true)
const pages = ref([])
const menuRefs = ref({})

// تعريف مسارات الصفحات الخاصة
const specialPages = {
  'الصفحة الرئيسية': '/',
  'عن الهيئة': '/about',
  'الخدمات': '/services',
  'التسهيلات الحكومية': '/gov-facilities',
  'أخبار': '/news',
  'أناشيد': '/media/nasheed',
  'فلاشات توعوية': '/media/flashes',
  'حلقات إذاعية': '/media/radio',
  'قصص النجاح': '/media/stories',
  'الدراسات': '/studies',
  'المشاريع': '/projects',
  'الإعلانات': '/ads',
  'إتصل بنا': '/contact',
  'روج لمشروعك': '/start',
  'سجل مشروعك': '/form/small-project-register',
  'شركاؤنا': '/partners',
  'الاسئلة الشائعة': '/faq',
  'الخريطة': '/map',
  'الشات بوت': '/chatbot',
  'الصفحة الشخصية': '/profile'
}

onMounted(async () => {
  // تحميل الثيم
  const saved = sessionStorage.getItem('theme')
  if (saved === 'dark') {
    isDark.value = true
  } else if (saved === 'light') {
    isDark.value = false
  } else {
    isDark.value = false
    sessionStorage.setItem('theme', 'light')
  }
  applyDarkMode()
  
  // تحميل البيانات من API
  await fetchPages()
  
  // إضافة حدث النقر خارج القوائم
  document.addEventListener('click', onClickOutside)
})

onBeforeUnmount(() => {
  document.removeEventListener('click', onClickOutside)
})

// In your <script setup> section, update the fetchPages function:

async function fetchPages() {
  try {
    loading.value = true
    
    // استبدل هذا بالرابط الفعلي لـ Laravel API الخاص بك
    // حاول استخدام localhost إذا كان Laravel يعمل محليًا
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    
    console.log('Fetching pages from:', `${API_URL}/pages-with-contents`)
    
    const response = await fetch(`${API_URL}/pages-with-contents`, {
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      mode: 'cors', // إضافة mode cors
      credentials: 'include' // إذا كنت تستخدم cookies
    })
    
    console.log('Response status:', response.status)
    console.log('Response headers:', response.headers)
    
    if (!response.ok) {
      const errorText = await response.text()
      console.error('HTTP error! status:', response.status, 'response:', errorText)
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('API Response:', result)
    
    if (result.success) {
      // استبعاد الصفحة الرئيسية فقط
      const fetchedPages = result.data.filter(page => page.name !== 'الصفحة الرئيسية')
      console.log('Filtered pages:', fetchedPages)
      
      if (fetchedPages.length === 0) {
        console.warn('No pages fetched from API, using defaults')
        pages.value = getDefaultPages()
      } else {
        pages.value = fetchedPages
      }
    } else {
      console.error('API returned success:false:', result.message)
      pages.value = getDefaultPages()
    }
  } catch (error) {
    console.error('Error fetching pages:', error)
    console.error('Error details:', error.message)
    
    // For testing, let's see what happens with a mock API call
    testMockAPI()
  } finally {
    loading.value = false
  }
}

// Add this function for testing
function testMockAPI() {
  console.log('Testing with mock data...')
  
  // محاكاة البيانات التي يجب أن تعود من Laravel
  const mockPages = [
    {
      id: 2,
      name: 'عن الهيئة',
      name_en: null,
      slug: 'عن-الهيئة',
      contents: [
        { id: 25, slug: 'من نحن', slug_en: null, page_id: 2 },
        { id: 26, slug: 'الرؤية', slug_en: null, page_id: 2 },
        { id: 27, slug: 'الرسالة', slug_en: null, page_id: 2 },
        { id: 28, slug: 'أهدافنا', slug_en: null, page_id: 2 },
        { id: 29, slug: 'قيمنا', slug_en: null, page_id: 2 }
      ]
    },
    {
      id: 3,
      name: 'الخدمات',
      name_en: null,
      slug: 'الخدمات',
      contents: [
        { id: 1, slug: 'خدمات التدريب', slug_en: null, page_id: 3 },
        { id: 2, slug: 'خدمات التسويق', slug_en: null, page_id: 3 },
        { id: 3, slug: 'خدمات التمويل', slug_en: null, page_id: 3 },
        { id: 4, slug: 'خدمات الاستشارات', slug_en: null, page_id: 3 }
      ]
    },
    {
      id: 4,
      name: 'التسهيلات الحكومية',
      name_en: null,
      slug: 'التسهيلات-الحكومية',
      contents: []
    },
    {
      id: 5,
      name: 'أخبار',
      name_en: null,
      slug: 'أخبار',
      contents: []
    },
    {
      id: 17,
      name: 'الاسئلة الشائعة',
      name_en: null,
      slug: 'الاسئلة-الشائعة',
      contents: [
        { id: 5, slug: 'هل الهيئة تمول؟', slug_en: null, page_id: 17 },
        { id: 6, slug: 'كيف تخدمون المشاريع الصغيرة؟', slug_en: null, page_id: 17 },
        { id: 7, slug: 'كيف أقدم على قرض؟', slug_en: null, page_id: 17 },
        { id: 8, slug: 'ما نوع التمويل المقدم من الهيئة؟', slug_en: null, page_id: 17 }
      ]
    },
    {
      id: 18,
      name: 'الخريطة',
      name_en: null,
      slug: 'الخريطة',
      contents: []
    },
    {
      id: 20,
      name: 'الشات بوت',
      name_en: null,
      slug: 'الشات-بوت',
      contents: []
    }
  ]
  
  console.log('Setting mock pages:', mockPages)
  pages.value = mockPages
}
function getDefaultPages() {
  // صفحات افتراضية للتحقق
  return [
    {
      id: 1,
      name: 'عن الهيئة',
      slug: 'عن-الهيئة',
      contents: [
        { id: 25, slug: 'من نحن', page_id: 2 },
        { id: 26, slug: 'الرؤية', page_id: 2 },
        { id: 27, slug: 'الرسالة', page_id: 2 },
        { id: 28, slug: 'أهدافنا', page_id: 2 },
        { id: 29, slug: 'قيمنا', page_id: 2 }
      ]
    },
    {
      id: 2,
      name: 'الخدمات',
      slug: 'الخدمات',
      contents: [
        { id: 1, slug: 'خدمات التدريب', page_id: 3 },
        { id: 2, slug: 'خدمات التسويق', page_id: 3 },
        { id: 3, slug: 'خدمات التمويل', page_id: 3 },
        { id: 4, slug: 'خدمات الاستشارات', page_id: 3 }
      ]
    },
    {
      id: 3,
      name: 'الاسئلة الشائعة',
      slug: 'الاسئلة-الشائعة',
      contents: [
        { id: 5, slug: 'هل الهيئة تمول؟', page_id: 17 },
        { id: 6, slug: 'كيف تخدمون المشاريع الصغيرة؟', page_id: 17 },
        { id: 7, slug: 'كيف أقدم على قرض؟', page_id: 17 },
        { id: 8, slug: 'ما نوع التمويل المقدم من الهيئة؟', page_id: 17 }
      ]
    },
    {
      id: 4,
      name: 'التسهيلات الحكومية',
      slug: 'التسهيلات-الحكومية',
      contents: [] // بدون محتويات فرعية
    },
    {
      id: 5,
      name: 'المشاريع',
      slug: 'المشاريع',
      contents: [] // بدون محتويات فرعية
    }
  ]
}

function toggle(which) {
  openMenu.value = openMenu.value === which ? null : which
}

function setMenuRef(slug, el) {
  menuRefs.value[slug] = el
}

function toggleMobileMenu(slug) {
  // هذا فقط لفتح وإغلاق القوائم في الموبايل
  const details = event.currentTarget.closest('details')
  if (details) {
    details.open = !details.open
  }
}

function getPageRoute(page) {
  // إرجاع المسار الخاص إذا كان موجودًا، وإلا إنشاء مسار ديناميكي
  return specialPages[page.name] || `/${page.slug}`
}

function getContentRoute(page, content) {
  // إذا كانت صفحة "عن الهيئة"، استخدم مسارات مخصصة
  if (page.name === 'عن الهيئة') {
    const contentRoutes = {
      'من نحن': '/about',
      'الرؤية': '/about#vision',
      'الرسالة': '/about#mission',
      'أهدافنا': '/about#goals',
      'قيمنا': '/about#values',
      'الأسئلة الشائعة': '/faq',
      'الشركاء': '/partners',
      'الدراسات': '/studies',
      'تواصل معنا': '/contact'
    }
    return contentRoutes[content.slug] || `/page/${page.slug}/${content.slug}`
  }
  
  // إذا كانت صفحة "قسم الإعلام والتوعية"
  if (page.name === 'قسم الإعلام والتوعية') {
    const mediaRoutes = {
      'فلاشات توعوية': '/media/flashes',
      'أخبار': '/news',
      'قصص نجاح': '/media/stories',
      'حلقات إذاعية': '/media/radio',
      'أناشيد': '/media/nasheed'
    }
    return mediaRoutes[content.slug] || `/media/${content.slug}`
  }
  
  // مسار افتراضي
  return `/page/${page.slug}/${content.slug}`
}

function toggleDark() {
  isDark.value = !isDark.value
  sessionStorage.setItem('theme', isDark.value ? 'dark' : 'light')
  applyDarkMode()
}

function applyDarkMode() {
  const html = document.documentElement
  if (isDark.value) html.classList.add('dark')
  else html.classList.remove('dark')
}

function onClickOutside(e) {
  if (!Object.values(menuRefs.value).some(el => el && el.contains(e.target))) {
    openMenu.value = null
  }
}

function goToRegisterProjectForm() {
  if (!isLoggedIn.value) {
    router.push({
      name: 'login',
      query: { redirect: '/form/small-project-register' },
    })
  } else {
    router.push('/form/small-project-register')
  }
}
</script>

<style scoped>
/* نفس الأنماط السابقة... */
.dd-item {
  @apply block rounded-lg px-3 py-2 transition-colors duration-150;
}
.dd-item:hover {
  background-color: #d8eaec;
  color: #185974;
}
.dd-item:active,
.dd-item:focus {
  background-color: #b2dade;
  color: #185974;
}

.nav-link {
  @apply inline-flex items-center;
  height: 48px;
  align-items: center;
}

.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s ease, transform 0.15s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(-4px);
}

.mobile-item {
  border-bottom: 1px solid #e5e7eb;
  padding: 0.7rem 0;
}
.dark .mobile-item {
  border-color: #1f2937;
}

.mobile-item summary {
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  list-style: none;
}
.mobile-item summary::-webkit-details-marker {
  display: none;
}

.mobile-item .children {
  margin-top: 0.4rem;
  padding-right: 2.2rem;
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}

.mobile-item .children a {
  display: block;
  padding: 0.25rem 0;
  font-size: 1rem;
  font-weight: 500;
  color: #185974;
  transition: color 0.15s ease;
}
.dark .mobile-item .children a {
  color: #E5F4F7;
}
.mobile-item .children a:hover {
  color: #27aeb9;
}

.dark .mobile-item .children {
  color: #cbd5f5;
}

.mobile-link {
  display: block;
  padding: 0.9rem 0;
  border-bottom: 1px solid #e5e7eb;
}
.dark .mobile-link {
  border-color: #1f2937;
}
.mobile-link:hover {
  color: #27aeb9;
}

.mobile-item summary:hover {
  color: #27aeb9;
}

.circle-arrow {
  width: 20px;
  height: 20px;
  border-radius: 999px;
  border: 1px solid #27aeb9;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.circle-arrow .chevron {
  width: 8px;
  height: 8px;
  border-right: 1.8px solid #27aeb9;
  border-bottom: 1.8px solid #27aeb9;
  transform: rotate(45deg);
  transform-origin: center;
  transition: transform 0.2s ease;
}

.mobile-item[open] .circle-arrow .chevron {
  transform: rotate(-135deg);
}
</style>