<template>
  <div class="mx-auto max-w-[1300px] px-4 mt-12 pb-20" dir="rtl">
    <!-- 🧭 breadcrumb -->
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
          {{ pageData.page_title || 'الشركاء المنفذون' }}
        </span>
      </nav>
    </div>

    <!-- العنوان -->
    <div class="mx-auto max-w-[1300px] px-4 mb-6">
      <h1
        class="text-3xl font-bold text-[#000000] dark:text-cyan-300 text-right mb-3"
      >
        {{ pageData.page_title || 'الشركاء المنفذون' }}
      </h1>
      
      <p
        v-if="pageData.page_description"
        class="text-slate-600 dark:text-slate-300 text-lg leading-8 w-full md:w-[85%] text-right"
      >
        {{ pageData.page_description }}
      </p>
      
      <!-- Loading state -->
      <div v-if="loading" class="space-y-3 mt-4">
        <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-1/2"></div>
        <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-3/4"></div>
      </div>
    </div>

    <!-- Loading skeleton -->
    <div v-if="loading" class="mx-auto max-w-[1300px] space-y-4">
      <div class="bg-white dark:bg-slate-900 rounded-[40px] p-8">
        <div class="grid gap-8 md:grid-cols-2 xl:grid-cols-4 justify-items-center">
          <div v-for="i in 8" :key="i" class="space-y-4">
            <div class="h-48 bg-gray-200 dark:bg-gray-700 rounded-[26px] animate-pulse w-full max-w-[260px]"></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Error state -->
    <div v-else-if="error" class="text-center py-12">
      <div class="text-red-500 mb-4">حدث خطأ في تحميل بيانات الشركاء المنفذين</div>
      <button 
        @click="fetchImplementationPartners"
        class="px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#134c5f] transition-colors"
      >
        حاول مرة أخرى
      </button>
    </div>

    <!-- Empty state -->
    <div v-else-if="!loading && (!partners || partners.length === 0)" class="text-center py-12">
      <div class="text-gray-500 mb-4">لا توجد بيانات للشركاء المنفذين متاحة حالياً</div>
      <button 
        @click="fetchImplementationPartners"
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
             shadow-sm px-4 md:px-10 py-10"
    >
      <!-- Number of partners -->
      <div class="text-center mb-8">
        <span class="text-[#165C75] dark:text-cyan-300 font-semibold text-lg">
          {{ partners.length }} شريك منفذ
        </span>
      </div>

      <!-- شبكة الكروت -->
      <div
        class="max-w-[1100px] mx-auto grid gap-8 md:grid-cols-2 xl:grid-cols-4 justify-items-center"
      >
        <article
          v-for="partner in partners"
          :key="partner.id"
          class="partner-logo-card w-full max-w-[260px] min-h-[200px]
                 bg-[#E6F3F5] dark:bg-slate-800
                 rounded-[26px]
                 border border-[#D6E8EB] dark:border-slate-700
                 shadow-sm flex flex-col items-center justify-center p-6
                 cursor-pointer hover:transform hover:-translate-y-1 transition-all duration-300"
          @click="showPartnerDetails(partner)"
        >
          <!-- الشعار -->
          <div class="mb-4 h-24 flex items-center justify-center">
            <img
              :src="getPartnerLogo(partner)"
              :alt="partner.name"
              class="max-h-[80px] max-w-[90%] object-contain"
              @error="handleImageError"
            />
          </div>
          
          <!-- الاسم -->
          <h3 class="text-[#165C75] dark:text-cyan-300 font-bold text-lg text-center mb-2">
            {{ partner.name }}
          </h3>
          
          <!-- الوصف المختصر -->
          <p v-if="partner.description" class="text-slate-600 dark:text-slate-300 text-sm leading-6 line-clamp-2 text-center">
            {{ partner.description }}
          </p>
          
          <!-- رابط الموقع -->
          <a 
            v-if="partner.website && isValidUrl(partner.website)" 
            :href="partner.website"
            target="_blank"
            rel="noopener noreferrer"
            @click.stop
            class="mt-4 text-[#165C75] dark:text-cyan-300 text-sm hover:underline flex items-center gap-1"
          >
            <svg class="w-4 h-4" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M12.586 4.586a2 2 0 112.828 2.828l-3 3a2 2 0 01-2.828 0 1 1 0 00-1.414 1.414 4 4 0 005.656 0l3-3a4 4 0 00-5.656-5.656l-1.5 1.5a1 1 0 101.414 1.414l1.5-1.5zm-5 5a2 2 0 012.828 0 1 1 0 101.414-1.414 4 4 0 00-5.656 0l-3 3a4 4 0 105.656 5.656l1.5-1.5a1 1 0 10-1.414-1.414l-1.5 1.5a2 2 0 11-2.828-2.828l3-3z" clip-rule="evenodd"/>
            </svg>
            زيارة الموقع
          </a>
        </article>
      </div>
    </div>

    <!-- Partner Details Modal -->
    <div v-if="selectedPartner" class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/50">
      <div 
        class="bg-white dark:bg-slate-900 rounded-[32px] w-full max-w-md p-8"
        @click.stop
      >
        <div class="flex justify-between items-center mb-6">
          <h3 class="text-xl font-bold text-[#165C75] dark:text-cyan-300">
            {{ selectedPartner.name }}
          </h3>
          <button 
            @click="selectedPartner = null"
            class="text-slate-500 hover:text-slate-700 dark:text-slate-400 dark:hover:text-slate-300"
          >
            <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
          </button>
        </div>
        
        <div class="space-y-4">
          <div class="flex justify-center">
            <img 
              :src="getPartnerLogo(selectedPartner)" 
              :alt="selectedPartner.name"
              class="max-h-32 object-contain"
            />
          </div>
          
          <div v-if="selectedPartner.description" class="text-slate-600 dark:text-slate-300">
            <p class="whitespace-pre-line">{{ selectedPartner.description }}</p>
          </div>
          
          <div v-if="selectedPartner.website && isValidUrl(selectedPartner.website)" 
               class="pt-4 border-t border-slate-200 dark:border-slate-700">
            <a 
              :href="selectedPartner.website"
              target="_blank"
              rel="noopener noreferrer"
              class="inline-flex items-center gap-2 text-[#165C75] dark:text-cyan-300 hover:underline"
            >
              <svg class="w-5 h-5" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M12.586 4.586a2 2 0 112.828 2.828l-3 3a2 2 0 01-2.828 0 1 1 0 00-1.414 1.414 4 4 0 005.656 0l3-3a4 4 0 00-5.656-5.656l-1.5 1.5a1 1 0 101.414 1.414l1.5-1.5zm-5 5a2 2 0 012.828 0 1 1 0 101.414-1.414 4 4 0 00-5.656 0l-3 3a4 4 0 105.656 5.656l1.5-1.5a1 1 0 10-1.414-1.414l-1.5 1.5a2 2 0 11-2.828-2.828l3-3z" clip-rule="evenodd"/>
              </svg>
              زيارة موقع الشريك
            </a>
          </div>
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
const selectedPartner = ref(null)

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

// Show partner details modal
const showPartnerDetails = (partner) => {
  selectedPartner.value = partner
}

// Fetch implementation partners from API
async function fetchImplementationPartners() {
  try {
    loading.value = true
    error.value = null
    
    // Use your Laravel API endpoint
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    
    // Try the main implementation partners endpoint
    const response = await fetch(`${API_URL}/implementation-partners`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('Fetched implementation partners:', result)
    
    if (result.success && result.data) {
      pageData.value = {
        page_title: result.data.page_title,
        page_description: result.data.page_description
      }
      partners.value = result.data.partners || []
    } else {
      // Try static endpoint
      await fetchStaticImplementationPartners()
    }
  } catch (err) {
    error.value = err.message
    console.error('Error fetching implementation partners:', err)
    
    // Fallback to static data
    await fetchStaticImplementationPartners()
  } finally {
    loading.value = false
  }
}

// Fetch static implementation partners
async function fetchStaticImplementationPartners() {
  try {
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    const response = await fetch(`${API_URL}/implementation-partners-static`)
    
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
      throw new Error(result.message || 'Failed to fetch static implementation partners')
    }
  } catch (err) {
    // Ultimate fallback to hardcoded data
    pageData.value = {
      page_title: 'الشركاء المنفذون',
      page_description: 'شركاؤنا الذين يعملون معنا على أرض الواقع لتنفيذ المشاريع والبرامج التنموية.'
    }
    
    partners.value = [
      {
        id: 1,
        name: 'الشريك المنفذ ١',
        description: 'منفذ مشاريع التصنيع الغذائي والتحسين الغذائي',
        logo_url: defaultLogo,
        website: null
      },
      {
        id: 2,
        name: 'الشريك المنفذ ٢',
        description: 'منفذ مشاريع الثروة الحيوانية والدواجن',
        logo_url: defaultLogo,
        website: null
      },
      {
        id: 3,
        name: 'الشريك المنفذ ٣',
        description: 'منفذ برامج التدريب المهني والتأهيل',
        logo_url: defaultLogo,
        website: null
      },
      {
        id: 4,
        name: 'الشريك المنفذ ٤',
        description: 'منفذ مشاريع الحرف اليدوية والتقليدية',
        logo_url: defaultLogo,
        website: null
      }
    ]
  }
}

// Fetch data when component mounts
onMounted(() => {
  fetchImplementationPartners()
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

/* Modal animation */
.modal-enter-active,
.modal-leave-active {
  transition: opacity 0.3s ease;
}

.modal-enter-from,
.modal-leave-to {
  opacity: 0;
}

.modal-content-enter-active,
.modal-content-leave-active {
  transition: all 0.3s ease;
}

.modal-content-enter-from,
.modal-content-leave-to {
  opacity: 0;
  transform: scale(0.95);
}
</style>