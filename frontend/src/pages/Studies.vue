<template>
  <div class="mx-auto max-w-[1300px] px-4 mt-12 pb-20" dir="rtl">
    <!-- Breadcrumb -->
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
        <span class="text-[#000000] dark:text-cyan-300 font-semibold">
          {{ pageTitle || 'الدراسات' }}
        </span>
      </nav>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-[#165C75]"></div>
      <p class="mt-4 text-slate-600 dark:text-slate-300">جاري تحميل الدراسات...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
      <div class="text-red-500 mb-4">⚠️ حدث خطأ في تحميل الدراسات</div>
      <p class="text-slate-600 dark:text-slate-300">{{ error }}</p>
      <button 
        @click="fetchStudies"
        class="mt-4 px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#124a5d] transition-colors"
      >
        إعادة المحاولة
      </button>
    </div>

    <!-- Main Content -->
    <div v-else>
      <!-- Title -->
      <div class="mx-auto max-w-[1300px] px-4 mb-4">
        <h1 class="text-3xl font-bold text-[#000000] dark:text-cyan-300 text-right">
          {{ pageTitle || 'الدراسات' }}
        </h1>
      </div>

      <!-- Description -->
      <div class="mx-auto max-w-[1300px] px-4 mb-6">
        <p class="text-right max-w-[900px] ml-auto text-slate-600 dark:text-slate-300 leading-8 text-[17px]">
          {{ pageDescription || 'تصفح دراساتنا الحديثة التي تسلط الضوء على المشاريع المحلية والتنمية الاقتصادية في اليمن، واكتشف كيف تسهم هذه الدراسات في تعزيز المعرفة والوعي ودعم اتخاذ القرار في مختلف المجالات.' }}
        </p>
      </div>

      <!-- Studies List -->
      <div v-if="studies && studies.length > 0">
        <div 
          v-for="(study, index) in studies"
          :key="study.id || index"
          class="mx-auto max-w-[1100px] mb-6 last:mb-0"
        >
          <!-- White Card Wrapper -->
          <div
            class="study-card bg-white dark:bg-slate-800 rounded-[32px]
                   border border-[#E5EDF0] dark:border-slate-700 shadow-sm px-4 md:px-6 py-5"
          >
            <div
              class="study-card flex flex-col md:flex-row items-stretch
                     bg-[#E9F5F6] dark:bg-slate-700
                     rounded-[24px] overflow-hidden"
            >
              <!-- Image Section -->
              <div class="w-full md:w-[32%] mb-4 md:mb-0">
                <!-- Image with safe loading -->
                <div class="w-full h-full">
                  <img
                    :src="study.display_image || getStudyImage(study)"
                    :alt="study.title"
                    class="w-full h-64 md:h-full object-cover rounded-2xl md:rounded-none"
                    @error="(e) => handleImageError(e, study)"
                    loading="lazy"
                  />
                </div>
              </div>

              <!-- Text + Button Section -->
              <div
                class="flex-1 px-4 md:px-8 py-3 md:py-5 text-right
                       flex flex-col justify-center gap-3"
              >
                <h2 class="text-xl md:text-[22px] font-bold text-[#165C75] dark:text-cyan-300">
                  {{ study.title }}
                </h2>

                <p class="text-slate-600 dark:text-slate-100 leading-7 text-[15px] md:text-[16px]">
                  {{ study.description }}
                </p>

                <div class="mt-2">
                  <a
                    v-if="study.file_url"
                    :href="study.file_url"
                    target="_blank"
                    class="btn btn-solid px-6 py-2 text-sm md:text-[15px] inline-block"
                    @click="trackDownload(study)"
                  >
                    تحميل الدراسة
                  </a>
                  <button
                    v-else
                    type="button"
                    class="btn btn-solid px-6 py-2 text-sm md:text-[15px] opacity-75 cursor-not-allowed"
                    disabled
                  >
                    غير متوفر للتحميل
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- No Studies State -->
      <div v-else class="text-center py-12">
        <div class="mx-auto max-w-[1100px] bg-white dark:bg-slate-800 rounded-[32px] border border-[#E5EDF0] dark:border-slate-700 shadow-sm p-8">
          <p class="text-slate-600 dark:text-slate-300">لا توجد دراسات متاحة حالياً</p>
          <button 
            @click="fetchStudies"
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
import { RouterLink } from "vue-router";
import { ref, onMounted } from "vue";

const loading = ref(true);
const error = ref(null);
const pageTitle = ref('');
const pageDescription = ref('');
const studies = ref([]);

// Default image for studies
const defaultStudyImage = '/images/news-1.jpg';

// Track errored images to prevent infinite loops
const erroredImages = ref(new Set());

// Fetch studies from API
async function fetchStudies() {
  try {
    loading.value = true;
    error.value = null;
    studies.value = [];
    erroredImages.value.clear(); // Reset error tracking
    
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api';
    const response = await fetch(`${API_URL}/studies-content`);
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const result = await response.json();
    console.log('Fetched studies data:', result);
    
    if (result.success && result.data) {
      pageTitle.value = result.data.page_title;
      pageDescription.value = result.data.page_description;
      
      // Process studies with proper image URLs
      studies.value = (result.data.studies || []).map(study => {
        // Pre-process the image URL to ensure it's valid
        const processedStudy = {
          ...study,
          display_image: null, // Will be set after image validation
          original_image_url: getStudyImage(study) // Store original URL
        };
        
        // Preload image to check if it exists
        preloadStudyImage(processedStudy);
        
        return processedStudy;
      });
    } else {
      // Fallback to static data
      await fetchStaticStudies();
    }
  } catch (err) {
    error.value = err.message;
    console.error('Error fetching studies:', err);
    
    // Fallback to static data
    await fetchStaticStudies();
  } finally {
    loading.value = false;
  }
}

// Preload study image to check if it exists
function preloadStudyImage(study) {
  const imageUrl = study.original_image_url;
  const studyKey = study.id || study.title;
  
  // Skip if we already know this image is invalid
  if (erroredImages.value.has(studyKey)) {
    study.display_image = defaultStudyImage;
    return;
  }
  
  const img = new Image();
  img.onload = () => {
    // Image loaded successfully
    study.display_image = imageUrl;
    // Force Vue reactivity update
    studies.value = [...studies.value];
  };
  img.onerror = () => {
    // Image failed to load
    erroredImages.value.add(studyKey);
    study.display_image = defaultStudyImage;
    // Force Vue reactivity update
    studies.value = [...studies.value];
  };
  img.src = imageUrl;
}

// Fallback static data function
async function fetchStaticStudies() {
  console.log('Using static studies data');
  pageTitle.value = 'الدراسات';
  pageDescription.value = 'تصفح دراساتنا الحديثة التي تسلط الضوء على المشاريع المحلية والتنمية الاقتصادية في اليمن، واكتشف كيف تسهم هذه الدراسات في تعزيز المعرفة والوعي ودعم اتخاذ القرار في مختلف المجالات.';
  
  studies.value = [
    {
      id: 1,
      title: 'تحليل سلسلة قيمة إنتاج الملابس المحلية',
      description: 'دراسة "سلسلة القيمة للملابس المحلية" تسلط الضوء على رحلة المنتجين الصغار في أمانة العاصمة، من التحديات إلى الفرص، وتطرح رؤية عملية لتطوير الجودة، وتوسيع الأسواق، وتعزيز حضور الملابس المحلية كمنافس قوي في السوق.',
      file_url: '/documents/study-1.pdf',
      image_url: null,
      display_image: defaultStudyImage,
      original_image_url: defaultStudyImage
    }
  ];
}

// Get study image - use provided image or default
function getStudyImage(study) {
  // First try image_url
  if (study.image_url) {
    return formatImageUrl(study.image_url);
  }
  
  // Check if file_url is an image
  if (study.file_url) {
    const imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
    const lowerUrl = study.file_url.toLowerCase();
    if (imageExtensions.some(ext => lowerUrl.endsWith(ext))) {
      return formatImageUrl(study.file_url);
    }
  }
  
  // Return default image
  return defaultStudyImage;
}

// Format image URL to ensure it's complete
function formatImageUrl(url) {
  if (!url) return defaultStudyImage;
  
  // If it's already a full URL, return as is
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url;
  }
  
  // If it starts with /, it's already a relative path
  if (url.startsWith('/')) {
    return url;
  }
  
  // If it's a relative path without leading slash
  return `/${url}`;
}

// Handle image loading errors - prevent infinite loops
function handleImageError(event, study) {
  const studyKey = study.id || study.title;
  const imgElement = event.target;
  
  // If we've already handled this image, don't do anything
  if (erroredImages.value.has(studyKey)) {
    return;
  }
  
  console.log(`Image failed to load for study: ${study.title}`);
  
  // Mark this image as errored
  erroredImages.value.add(studyKey);
  
  // Update the study object
  const studyIndex = studies.value.findIndex(s => 
    (s.id === study.id) || (s.title === study.title)
  );
  
  if (studyIndex !== -1) {
    studies.value[studyIndex].display_image = defaultStudyImage;
    // Force Vue reactivity update
    studies.value = [...studies.value];
  }
  
  // Update the image src directly and remove error handler
  imgElement.src = defaultStudyImage;
  imgElement.onerror = null;
  
  // Prevent default error handling
  event.preventDefault();
}

// Track study downloads (optional)
function trackDownload(study) {
  console.log(`Downloading study: ${study.title}`);
  // Here you could send analytics data to your backend
  // Example:
  // fetch(`${API_URL}/track-download/${study.id}`, { method: 'POST' });
}

// Fetch data when component mounts
onMounted(() => {
  fetchStudies();
});
</script>

<style scoped>
.study-card {
  transition:
    transform .35s cubic-bezier(.2,.9,.3,1),
    box-shadow .35s ease,
    border-color .35s ease,
    background-color .35s ease;
  box-shadow: 0 8px 22px rgba(15,76,92,0.10);
}

.study-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 20px 36px rgba(15,76,92,0.18);
  border-color: #C7E4E7;
}

/* Button styling - ensure btn-solid is defined */
.btn.btn-solid {
  background-color: #165C75;
  color: white;
  border: none;
  border-radius: 0.5rem;
  padding: 0.5rem 1.5rem;
  font-weight: 500;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.btn.btn-solid:hover {
  background-color: #124a5d;
}

.btn.btn-solid:disabled {
  background-color: #94a3b8;
  cursor: not-allowed;
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

/* Ensure images have proper aspect ratio */
img {
  max-width: 100%;
  height: auto;
  display: block;
}

/* Add min-height to prevent layout shift */
.w-full.md\:w-\[32\%\] {
  min-height: 200px;
}

/* Image container styling */
.w-full.h-full.object-cover {
  background-color: #f3f4f6; /* Light gray background while loading */
}

.dark .w-full.h-full.object-cover {
  background-color: #374151; /* Dark gray background in dark mode */
}
</style>