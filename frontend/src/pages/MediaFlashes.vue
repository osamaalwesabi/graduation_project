<template>
  <div class="mx-auto mt-12 max-w-[1300px] px-4 pb-20" dir="rtl">
    <!-- Loading State -->
    <div v-if="loading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-[#165C75]"></div>
      <p class="mt-4 text-slate-600 dark:text-slate-300">جاري تحميل الفلاشات التوعوية...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
      <div class="text-red-500 mb-4">⚠️ حدث خطأ في تحميل الفلاشات التوعوية</div>
      <p class="text-slate-600 dark:text-slate-300">{{ error }}</p>
      <button 
        @click="fetchAwarenessFlashes"
        class="mt-4 px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#124a5d] transition-colors"
      >
        إعادة المحاولة
      </button>
    </div>

    <!-- Main Content -->
    <div v-else>
      <!-- Breadcrumb -->
      <nav
        class="mx-auto max-w-[1300px] px-4 text-slate-500 dark:text-slate-400 text-sm
               flex items-center gap-2 mb-4"
      >
        <RouterLink to="/" class="hover:text-[#165C75] dark:hover:text-cyan-300">
          الرئيسية
        </RouterLink>
        <span>›</span>
        <RouterLink
          to="/media"
          class="hover:text-[#165C75] dark:hover:text-cyan-300"
        >
          قسم الإعلام والتوعية
        </RouterLink>
        <span>›</span>
        <span class="text-[#000000] dark:text-cyan-300 font-semibold">
          {{ pageTitle || 'الفلاشات التوعوية' }}
        </span>
      </nav>

      <!-- العنوان + الوصف -->
      <div class="mx-auto max-w-[1300px] px-4 mb-6">
        <h1
          class="text-3xl font-bold text-[#000000] dark:text-cyan-300 mb-3 text-right"
        >
          {{ pageTitle || 'الفلاشات التوعوية' }}
        </h1>
        
        <p 
          v-if="pageDescription"
          class="text-gray-600 dark:text-slate-300 mb-8 leading-relaxed max-w-[850px] text-right"
        >
          {{ pageDescription }}
        </p>
      </div>

      <!-- Sections Grid -->
      <div
        v-if="sections && sections.length > 0"
        class="mx-auto max-w-[1300px] bg-white dark:bg-slate-900 rounded-[40px]
               border border-[#E5EDF0] dark:border-slate-700 shadow-sm
               px-6 md:px-10 py-10"
      >
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-1 gap-8">
          <RouterLink
            v-for="section in sections"
            :key="section.id"
            :to="section.link"
            class="section-card bg-[#E9F5F6] dark:bg-slate-800
                   rounded-3xl p-6 border border-[#D8EDEE] dark:border-slate-700
                   shadow-sm block transition-all duration-300"
          >
            <!-- Section Image -->
            <div class="mb-4">
              <img
                :src="getSectionImage(section)"
                :alt="section.title"
                class="w-full h-48 object-cover rounded-2xl"
                @error="handleImageError"
              />
            </div>

            <!-- Section Content -->
            <div class="text-right">
              <h3 class="text-xl font-bold text-[#165C75] dark:text-cyan-300 mb-2">
                {{ section.title }}
              </h3>
              
              <!-- <p class="text-slate-600 dark:text-slate-100 leading-7 text-[15px] line-clamp-2 mb-3">
                {{ section.description }}
              </p>
               -->
              <!-- Videos Count -->
              <div class="flex items-center justify-between">
                <span class="text-sm text-slate-500 dark:text-slate-400">
                  {{ section.videos_count || 0 }} فيديو
                </span>
                
                <span class="inline-flex items-center text-[#165C75] dark:text-cyan-300 font-medium">
                  <span>عرض الفيديوهات</span>
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
                  </svg>
                </span>
              </div>
            </div>
          </RouterLink>
        </div>
      </div>

      <!-- No Sections State -->
      <div v-else class="text-center py-12">
        <div class="mx-auto max-w-[1300px] bg-white dark:bg-slate-900 rounded-[40px] border border-[#E5EDF0] dark:border-slate-700 shadow-sm p-8">
          <p class="text-slate-600 dark:text-slate-300">لا توجد أقسام فلاشات توعوية متاحة حالياً</p>
          <button 
            @click="fetchAwarenessFlashes"
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
import { ref, onMounted } from 'vue'

const loading = ref(true)
const error = ref(null)
const pageTitle = ref('')
const pageDescription = ref('')
const sections = ref([])

// Fetch awareness flashes sections from API
async function fetchAwarenessFlashes() {
  try {
    loading.value = true
    error.value = null
    
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    const response = await fetch(`${API_URL}/awareness-flashes-content`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('Fetched awareness flashes sections:', result)
    
    if (result.success && result.data) {
      pageTitle.value = result.data.page_title
      pageDescription.value = result.data.page_description
      sections.value = result.data.sections || []
    } else {
      // Fallback to static data
      await fetchStaticSections()
    }
  } catch (err) {
    error.value = err.message
    console.error('Error fetching awareness flashes sections:', err)
    
    // Fallback to static data
    await fetchStaticSections()
  } finally {
    loading.value = false
  }
}

// Fallback static data function
async function fetchStaticSections() {
  console.log('Using static awareness flashes sections')
  pageTitle.value = 'الفلاشات التوعوية'
  pageDescription.value = ''
  
  sections.value = [
    {
      id: 1,
      title: 'فيديوهات توعوية (الصناعات المنزلية)',
      description: 'مجموعة فيديوهات توضح خطوات الصناعات الغذائية المنزلية بطريقة آمنة وسهلة.',
      image: '/assets/images/flash-1.png',
      slug: 'home-industry',
      link: '/media/flashes/home-industry',
      videos_count: 6,
      type: 'awareness_section'
    },
    {
      id: 2,
      title: 'فلاشات توعوية (الصحة الحيوانية)',
      description: 'مواد مرئية توعوية للحفاظ على صحة المواشي وتحسين الإنتاج.',
      image: '/assets/images/flash-1.png',
      slug: 'animal-health',
      link: '/media/flashes/animal-health',
      videos_count: 3,
      type: 'awareness_section'
    },
    {
      id: 3,
      title: 'سلسلة تعلّم في دقيقة',
      description: 'فيديوهات سريعة تسلط الضوء على مهارات ونصائح لأصحاب المشاريع الصغيرة.',
      image: '/assets/images/flash-1.png',
      slug: 'learn-in-a-minute',
      link: '/media/flashes/learn-in-a-minute',
      videos_count: 6,
      type: 'awareness_section'
    }
  ]
}

// Get section image
function getSectionImage(section) {
  if (section.image && section.image !== '/assets/images/flash-1.png') {
    // If image is already a full URL or starts with /, use as is
    if (section.image.startsWith('http') || section.image.startsWith('/')) {
      return section.image
    }
    // Otherwise, prepend with /assets/images/
    return `/assets/images/${section.image}`
  }
  
  // Use default image
  return '/assets/images/flash-1.png'
}

// Handle image loading errors
function handleImageError(event) {
  console.log('Section image failed to load, using default')
  event.target.src = '/assets/images/flash-1.png'
}

// Fetch data when component mounts
onMounted(() => {
  fetchAwarenessFlashes()
})
</script>

<style scoped>
.section-card {
  transition:
    transform .35s cubic-bezier(.2,.9,.3,1),
    box-shadow .35s ease,
    border-color .35s ease,
    background-color .35s ease;
  box-shadow: 0 8px 22px rgba(15,76,92,0.10);
}

.section-card:hover {
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