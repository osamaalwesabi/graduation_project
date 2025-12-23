<template>
  <div class="mx-auto max-w-[1300px] px-4 mt-12 pb-20" dir="rtl">
    <!-- Loading State -->
    <div v-if="loading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-[#165C75]"></div>
      <p class="mt-4 text-slate-600 dark:text-slate-300">جاري تحميل الخدمات...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
      <div class="text-red-500 mb-4">⚠️ حدث خطأ في تحميل الخدمات</div>
      <p class="text-slate-600 dark:text-slate-300">{{ error }}</p>
      <button 
        @click="fetchServices"
        class="mt-4 px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#124a5d] transition-colors"
      >
        إعادة المحاولة
      </button>
    </div>

    <!-- Main Content -->
    <div v-else>
      <!-- Breadcrumb -->
      <div class="mx-auto max-w-[1300px] px-4 mt-6 mb-4">
        <nav class="text-slate-500 dark:text-slate-400 text-sm flex items-center gap-2">
          <RouterLink to="/" class="hover:text-[#165C75] dark:hover:text-cyan-300">
            الرئيسية
          </RouterLink>
          <span>›</span>
          <span class="text-[#000000] dark:text-cyan-300 font-semibold">
            {{ pageTitle || 'الخدمات' }}
          </span>
        </nav>
      </div>

      <!-- Page Title -->
      <div class="mx-auto max-w-[1300px] px-4 mb-6">
        <h1
          class="text-3xl font-bold text-[#000000] dark:text-cyan-300 mb-3 text-right"
        >
          {{ pageTitle || 'خدمات الهيئة' }}
        </h1>

        <p
          class="text-gray-600 dark:text-slate-300 mb-8 leading-relaxed max-w-[850px] text-right"
        >
          {{ pageDescription || 'في الهيئة العامة لتنمية المشاريع الصغيرة والأصغر، نعمل على تقديم مجموعة متكاملة من الخدمات التي تهدف إلى دعم أصحاب المشاريع في جميع المراحل.' }}
        </p>
      </div>

      <!-- Services Grid -->
      <div
        v-if="services && services.length > 0"
        class="mx-auto max-w-[1300px] bg-white dark:bg-slate-900 rounded-[40px]
               border border-[#E5EDF0] dark:border-slate-700 shadow-sm p-8 md:p-10"
      >
        <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6 md:gap-8 justify-items-center">
          <ServiceCard
            v-for="service in services"
            :key="service.id"
            :image="getServiceImage(service)"
            :title="service.title"
            :desc="service.desc"
            :link="service.link"
          />
        </div>
      </div>

      <!-- No Services State -->
      <div v-else class="text-center py-12">
        <div class="mx-auto max-w-[1300px] bg-white dark:bg-slate-900 rounded-[40px] border border-[#E5EDF0] dark:border-slate-700 shadow-sm p-8">
          <p class="text-slate-600 dark:text-slate-300">لا توجد خدمات متاحة حالياً</p>
          <button 
            @click="fetchServices"
            class="mt-4 px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#124a5d] transition-colors"
          >
            تحديث الصفحة
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { RouterLink } from 'vue-router'
import ServiceCard from '@/components/ServiceCard.vue'
import { ref, onMounted } from 'vue'

const loading = ref(true)
const error = ref(null)
const pageTitle = ref('')
const pageDescription = ref('')
const services = ref([])

// Fetch services from API
async function fetchServices() {
  try {
    loading.value = true
    error.value = null
    
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    const response = await fetch(`${API_URL}/services-content`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('Fetched services data:', result)
    
    if (result.success && result.data) {
      pageTitle.value = result.data.page_title
      pageDescription.value = result.data.page_description
      services.value = result.data.services || []
    } else {
      // Fallback to static data
      await fetchStaticServices()
    }
  } catch (err) {
    error.value = err.message
    console.error('Error fetching services:', err)
    
    // Fallback to static data
    await fetchStaticServices()
  } finally {
    loading.value = false
  }
}

// Fallback static data function
async function fetchStaticServices() {
  console.log('Using static services data')
  pageTitle.value = 'خدمات الهيئة'
  pageDescription.value = 'في الهيئة العامة لتنمية المشاريع الصغيرة والأصغر، نعمل على تقديم مجموعة متكاملة من الخدمات التي تهدف إلى دعم أصحاب المشاريع في جميع المراحل.'
  
  services.value = [
    {
      id: 1,
      title: 'خدمة التدريب',
      desc: 'تقدم الهيئة برامج تدريبية متخصصة تهدف إلى تطوير مهارات رواد الأعمال والمشاريع الصغيرة في مجالات التصنيع الغذائي، الجلود الطبيعية، الخياطة، الحرف اليدوية، وريادة الأعمال.',
      image: '/assets/services/training.jpg',
      link: '/services/training'
    },
    {
      id: 2,
      title: 'خدمة التسويق',
      desc: 'نسعى لتسويق منتجات المشاريع الصغيرة عبر المعارض والفعاليات والمنصات الرقمية، لتمكينها من الوصول إلى أسواق أوسع وزيادة فرص نجاحها.',
      image: '/assets/services/marketing.jpg',
      link: '/services/marketing'
    },
    {
      id: 3,
      title: 'خدمة التمويل',
      desc: 'تقدم الهيئة قروضاً بيضاء عبر الجمعيات الشريكة لدعم المشاريع في مجالات الثروة الحيوانية، الصيد البحري، التصنيع الغذائي، الخياطة، والحرف اليدوية.',
      image: '/assets/services/funding.jpg',
      link: '/services/funding'
    },
    {
      id: 4,
      title: 'خدمة الاستشارات',
      desc: 'نقدم استشارات متخصصة تساعد أصحاب المشاريع على النمو والتطور، مع التركيز على التخطيط، الإدارة، الإنتاج، والتسويق.',
      image: '/assets/services/consulting.jpg',
      link: '/services/consulting'
    }
  ]
}

// Get service image - handle both absolute and relative URLs
function getServiceImage(service) {
  if (!service.image) {
    return '/assets/images/logo.png'
  }
  
  // If image is already a full URL or starts with /, use as is
  if (service.image.startsWith('http') || service.image.startsWith('/')) {
    return service.image
  }
  
  // Otherwise, prepend with /assets/services/ if it's just a filename
  return `/assets/services/${service.image}`
}

// Handle image loading errors
function handleImageError(event, service) {
  console.log(`Image failed to load for ${service.title}, using default`)
  event.target.src = '/assets/images/logo.png'
}

// Fetch data when component mounts
onMounted(() => {
  fetchServices()
})
</script>

<style scoped>
/* Loading spinner animation */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}
</style>