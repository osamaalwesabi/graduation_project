<template>
  <div class="mx-auto max-w-[1300px] px-4 mt-12 pb-20" dir="rtl">
    <!-- 🧭 Breadcrumb -->
    <div class="mx-auto max-w-[1300px] px-4 mt-6 mb-4">
      <nav class="text-slate-500 dark:text-slate-400 text-sm flex items-center gap-2">
        <RouterLink to="/" class="hover:text-[#165C75] dark:hover:text-cyan-300">
          الرئيسية
        </RouterLink>
        <span>›</span>
        <RouterLink to="/about" class="hover:text-[#165C75] dark:hover:text-cyan-300">
          عن الهيئة
        </RouterLink>
        <span>›</span>
        <RouterLink to="/partners" class="hover:text-[#165C75] dark:hover:text-cyan-300">
          الشركاء
        </RouterLink>
        <span>›</span>
        <span class="text-[#000000] dark:text-cyan-300 font-semibold">
          {{ pageData.page_title || 'الشركاء الممولون' }}
        </span>
      </nav>
    </div>

    <!-- العنوان -->
    <div class="mx-auto max-w-[1300px] px-4 mb-6">
      <h1
        class="text-3xl font-bold text-[#000000] dark:text-cyan-300 text-right mb-3"
      >
        {{ pageData.page_title || 'الشركاء الممولون' }}
      </h1>
      
      <p
        v-if="pageData.page_description"
        class="text-slate-600 dark:text-slate-300 text-lg leading-8 w-full md:w-[85%] text-right"
      >
        {{ pageData.page_description }}
      </p>
    </div>

    <!-- Loading skeleton -->
    <div v-if="loading" class="mx-auto max-w-[1300px] space-y-4">
      <div class="bg-white dark:bg-slate-900 rounded-[40px] p-8">
        <div class="grid md:grid-cols-3 gap-8 justify-items-center">
          <div v-for="i in 6" :key="i" class="space-y-4">
            <div class="h-48 bg-gray-200 dark:bg-gray-700 rounded-[32px] animate-pulse w-full max-w-[260px]"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Error state -->
    <div v-else-if="error" class="text-center py-12">
      <div class="text-red-500 mb-4">حدث خطأ في تحميل بيانات الشركاء الممولين</div>
      <button 
        @click="fetchFundingPartners"
        class="px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#134c5f] transition-colors"
      >
        حاول مرة أخرى
      </button>
    </div>

    <!-- Empty state -->
    <div v-else-if="!loading && (!partners || partners.length === 0)" class="text-center py-12">
      <div class="text-gray-500 mb-4">لا توجد بيانات للشركاء الممولين متاحة حالياً</div>
      <button 
        @click="fetchFundingPartners"
        class="px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#134c5f] transition-colors"
      >
        تحديث الصفحة
      </button>
    </div>

    <!-- 🟦 الكارد الأبيض الكبير -->
    <div
      v-else
      class="mx-auto max-w-[1300px] bg-white dark:bg-slate-900 rounded-[40px]
             border border-[#E5EDF0] dark:border-slate-700
             shadow-sm px-4 md:px-10 py-10 mb-10"
    >
      <!-- Number of partners -->
      <div class="text-center mb-8">
        <span class="text-[#165C75] dark:text-cyan-300 font-semibold text-lg">
          {{ partners.length }} شريك ممول
        </span>
      </div>

      <!-- شبكة الشعارات -->
      <div
        class="max-w-[1100px] mx-auto grid md:grid-cols-2 lg:grid-cols-3 gap-8 justify-items-center"
      >
         <div
          v-for="partner in partners"
          :key="i"
          class="partner-logo-card
                 bg-[#E6F3F5] dark:bg-slate-800
                 border border-[#D6E8EB] dark:border-slate-700
                 shadow-sm rounded-[32px]
                 p-8 flex items-center justify-center
                 w-full max-w-[260px] h-[200px]"
        >
          <img :src="getPartnerLogo(partner)" class="max-h-[140px] max-w-[90%] object-contain" />
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { RouterLink } from 'vue-router'

// Import default partner logo for fallback
import defaultLogo from '@/assets/images/partner-ex-1.png'

// Reactive data
const pageData = ref({
  page_title: '',
  page_description: ''
})
const partners = ref([])
const loading = ref(true)
const error = ref(null)

// Check if URL is valid
const isValidUrl = (url) => {
  if (!url || url.trim() === '') return false
  try {
    new URL(url)
    return true
  } catch {
    return false
  }
}

// Get partner logo with fallback
const getPartnerLogo = (partner) => {
  if (partner.logo_url && isValidUrl(partner.logo_url)) {
    return partner.logo_url
  }
  
  // Check if it's a relative path starting with @
  if (partner.logo_url && partner.logo_url.startsWith('@/')) {
    // Convert @/assets to actual path
    return partner.logo_url.replace('@/', '/')
  }
  
  // Fallback to default logo
  return defaultLogo
}

// Handle image loading error
const handleImageError = (event) => {
  event.target.src = defaultLogo
}

// Fetch funding partners from API
async function fetchFundingPartners() {
  try {
    loading.value = true
    error.value = null
    
    // Use your Laravel API endpoint
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    
    // Try the main funding partners endpoint
    const response = await fetch(`${API_URL}/funding-partners`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('Fetched funding partners:', result)
    
    if (result.success && result.data) {
      pageData.value = {
        page_title: result.data.page_title,
        page_description: result.data.page_description
      }
      partners.value = result.data.partners || []
      
      // Debug: Log the partners data
      console.log('Partners loaded:', partners.value)
    } else {
      // Try static endpoint
      // await fetchStaticFundingPartners()
    }
  } catch (err) {
    error.value = err.message
    console.error('Error fetching funding partners:', err)
    
    // Fallback to static data
    // await fetchStaticFundingPartners()
  } finally {
    loading.value = false
  }
}

// Fetch static funding partners
async function fetchStaticFundingPartners() {
  try {
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    const response = await fetch(`${API_URL}/funding-partners-static`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    
    if (result.success && result.data) {
      pageData.value = {
        page_title: result.data.page_title,
        page_description: result.data.page_description
      }
      partners.value = result.data.partners || []
    } else {
      throw new Error(result.message || 'Failed to fetch static funding partners')
    }
  } catch (err) {
    // Ultimate fallback to hardcoded data
    pageData.value = {
      page_title: 'الشركاء الممولون',
      page_description: 'شركاؤنا الذين يدعموننا ماليًا لتحقيق أهدافنا التنموية في خدمة المشاريع الصغيرة والأصغر.'
    }
    
    partners.value = [
      {
        id: 1,
        name: 'الجهة الممولة ١',
        description: 'داعم رئيسي للمشاريع الصغيرة والأصغر في مجالات متعددة.',
        logo_url: defaultLogo,
        website: null
      },
      {
        id: 2,
        name: 'الجهة الممولة ٢',
        description: 'ممول برامج التدريب والتأهيل للمشاريع الناشئة.',
        logo_url: defaultLogo,
        website: null
      },
      {
        id: 3,
        name: 'الجهة الممولة ٣',
        description: 'داعم مشاريع التمويل الصغير في المناطق الريفية.',
        logo_url: defaultLogo,
        website: null
      },
      {
        id: 4,
        name: 'الجهة الممولة ٤',
        description: 'ممول المشاريع الزراعية والثروة الحيوانية.',
        logo_url: defaultLogo,
        website: null
      },
      {
        id: 5,
        name: 'الجهة الممولة ٥',
        description: 'داعم برامج التصنيع الغذائي والحرف اليدوية.',
        logo_url: defaultLogo,
        website: null
      }
    ]
  }
}

// Fetch data when component mounts
onMounted(() => {
  fetchFundingPartners()
})
</script>

<style scoped>
.partner-logo-card {
  transition:
    transform .35s cubic-bezier(.2,.9,.3,1),
    box-shadow .35s ease,
    border-color .35s ease,
    background-color .35s ease;
  box-shadow: 0 8px 22px rgba(15,76,92,0.10);
}

.partner-logo-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 20px 36px rgba(15,76,92,0.18);
  border-color: #C7E4E7;
}

.line-clamp-2 {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
</style>