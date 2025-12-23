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
        <div class="grid grid-cols-1 md:grid-cols-1 lg:grid-cols-1 gap-8">
          <RouterLink
            v-for="section in sections"
            :key="section.id"
            :to="section.link"
            class="section-card bg-[#E9F5F6] dark:bg-slate-800
                   rounded-3xl p-6 border border-[#D8EDEE] dark:border-slate-700
                   shadow-sm block transition-all duration-300"
          >
            <!-- Section Image with simple error handling -->
            <div class="mb-4 h-48 rounded-2xl overflow-hidden dark:bg-slate-700">
              <img
                :src="section.final_image_url || section.image_url || section.image || '/assets/images/flash-1.png'"
                :alt="section.title"
                class="w-full h-full object-cover"
                @error="(e) => handleImageErrorOnce(e, section)"
                loading="lazy"
              />
            </div>

            <!-- Section Content -->
            <div class="text-right">
              <h3 class="text-xl font-bold text-[#165C75] dark:text-cyan-300 mb-2">
                {{ section.title }}
              </h3>
              
              
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

// Track which images have already errored
const erroredImages = ref(new Set())

// Fetch awareness flashes sections from API
async function fetchAwarenessFlashes() {
  try {
    loading.value = true
    error.value = null
    sections.value = []
    erroredImages.value.clear() // Reset error tracking
    
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
      
      // Process sections with proper image URLs
      sections.value = (result.data.sections || []).map(section => {
        // Get the best available image URL
        const imageUrl = getBestImageUrl(section)
        
        return {
          ...section,
          image_url: imageUrl,
          final_image_url: null // This will be set if image fails to load
        }
      })
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
      image_url: '/assets/images/flash-1.png',
      final_image_url: null,
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
      image_url: '/assets/images/flash-1.png',
      final_image_url: null,
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
      image_url: '/assets/images/flash-1.png',
      final_image_url: null,
      slug: 'learn-in-a-minute',
      link: '/media/flashes/learn-in-a-minute',
      videos_count: 6,
      type: 'awareness_section'
    }
  ]
}

// Get the best available image URL for a section
function getBestImageUrl(section) {
  // Try different image sources in order of preference
  const sources = [
    section.image,        // Original image field
    section.image_url,    // Processed image_url field
    '/assets/images/flash-1.png' // Default
  ].filter(Boolean) // Remove null/undefined values
  
  // Return the first valid source
  for (const source of sources) {
    if (source) {
      return formatImageUrl(source)
    }
  }
  
  return '/assets/images/flash-1.png'
}

// Format image URL to ensure it's complete
function formatImageUrl(url) {
  if (!url) return '/assets/images/flash-1.png'
  
  // If it's already a full URL, return as is
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url
  }
  
  // If it starts with /, it's already a relative path
  if (url.startsWith('/')) {
    return url
  }
  
  // Otherwise, assume it's relative to /assets/images/
  return `/assets/images/${url}`
}

// Handle image error - only once per image
function handleImageErrorOnce(event, section) {
  const sectionKey = `${section.id}-${section.title}`
  
  // If we've already tried to fix this image, don't do it again
  if (erroredImages.value.has(sectionKey)) {
    return
  }
  
  // Mark this image as errored
  erroredImages.value.add(sectionKey)
  
  console.log(`Image failed to load for section: ${section.title}`)
  
  // Find the section in the array and update its final_image_url
  const sectionIndex = sections.value.findIndex(s => s.id === section.id)
  if (sectionIndex !== -1) {
    // Use a default image
    sections.value[sectionIndex].final_image_url = '/assets/images/flash-1.png'
    
    // Force Vue to update the DOM
    sections.value = [...sections.value]
  }
  
  // Update the image src directly
  event.target.src = '/assets/images/flash-1.png'
  
  // Remove the error listener to prevent infinite loops
  event.target.onerror = null
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

/* Ensure images don't cause layout shifts */
img {
  max-width: 100%;
  height: auto;
  display: block;
}

/* Add background color for image container */
.bg-gray-100 {
  background-color: #f3f4f6;
}

.dark .bg-slate-700 {
  background-color: #334155;
}
</style>