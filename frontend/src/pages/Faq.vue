<template>
  <div class="mx-auto max-w-[1300px] px-4 mt-12 pb-20" dir="rtl">
    <!-- Breadcrumb -->
    <div class="mx-auto max-w-[1300px] px-4 mt-6 mb-4">
      <nav
        class="text-slate-500 dark:text-slate-400 text-sm flex items-center gap-2"
      >
        <RouterLink
          to="/"
          class="hover:text-[#165C75] dark:hover:text-cyan-300"
        >
          الرئيسية
        </RouterLink>
        <span>›</span>
        <RouterLink
          to="/about"
          class="hover:text-[#165C75] dark:hover:text-cyan-300"
        >
          عن الهيئة
        </RouterLink>
        <span>›</span>
        <span class="text-[#000000] dark:text-cyan-300 font-semibold">
          {{ pageData.page_title || 'الأسئلة الشائعة' }}
        </span>
      </nav>
    </div>

    <!-- Page Title -->
    <div class="mx-auto max-w-[1300px] px-4 mb-6">
      <h1
        class="text-3xl font-bold text-[#1A1A1A] dark:text-slate-50 mb-2 text-right"
      >
        {{ pageData.page_title || 'الأسئلة الشائعة' }}
      </h1>
      
      <p
        v-if="pageData.page_description"
        class="text-slate-600 dark:text-slate-300 text-lg leading-8 w-full md:w-[85%] text-right"
      >
        {{ pageData.page_description }}
      </p>
      
      <!-- Loading state for description -->
      <div v-if="loading" class="space-y-3">
        <div class="h-6 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-3/4"></div>
        <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-full"></div>
      </div>
    </div>

    <!-- Loading skeleton -->
    <div v-if="loading" class="mx-auto max-w-[1300px] space-y-4">
      <div 
        v-for="i in 5" 
        :key="i"
        class="bg-white dark:bg-slate-900 rounded-xl p-6 space-y-3"
      >
        <div class="h-5 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-3/4"></div>
        <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-full"></div>
        <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-2/3"></div>
      </div>
    </div>

    <!-- Error state -->
    <div v-else-if="error" class="text-center py-12">
      <div class="text-red-500 mb-4">حدث خطأ في تحميل الأسئلة الشائعة</div>
      <button 
        @click="fetchFAQContent"
        class="px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#134c5f] transition-colors"
      >
        حاول مرة أخرى
      </button>
    </div>

    <!-- Empty state -->
    <div v-else-if="!loading && (!faqItems || faqItems.length === 0)" class="text-center py-12">
      <div class="text-gray-500 mb-4">لا توجد أسئلة شائعة متاحة حالياً</div>
      <button 
        @click="fetchFAQContent"
        class="px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#134c5f] transition-colors"
      >
        تحديث الصفحة
      </button>
    </div>

    <!-- الكارد الأبيض الموحد -->
    <div
      v-else-if="!loading && faqItems && faqItems.length > 0"
      class="mx-auto max-w-[1300px]
             bg-white dark:bg-slate-900
             rounded-[40px]
             border border-[#E5EDF0] dark:border-slate-700
             shadow-sm p-6 md:p-8 lg:p-10"
    >
      <!-- Search bar (optional) -->
      <div class="mb-8">
        <div class="relative">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="ابحث عن سؤال..."
            class="w-full px-4 py-3 pr-12 rounded-xl border border-[#D6E8EB] dark:border-slate-700
                   bg-white dark:bg-slate-800
                   text-slate-700 dark:text-slate-200
                   focus:outline-none focus:ring-2 focus:ring-[#165C75] dark:focus:ring-cyan-300
                   transition-all"
          />
          <svg
            class="absolute left-4 top-1/2 transform -translate-y-1/2 w-5 h-5 text-slate-400"
            viewBox="0 0 20 20"
            fill="currentColor"
          >
            <path
              fill-rule="evenodd"
              d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        
        <!-- Search results count -->
        <div v-if="searchQuery" class="mt-2 text-sm text-slate-500 dark:text-slate-400">
          {{ filteredItems.length }} من {{ faqItems.length }} نتيجة
        </div>
      </div>

      <!-- FAQ Items -->
      <div class="w-full mx-auto space-y-4">
        <div
          v-for="(item, index) in filteredItems"
          :key="item.id || index"
          class="mb-4"
        >
          <!-- السؤال -->
          <div
            @click="toggle(index)"
            class="cursor-pointer
                   bg-[#DFF1F4] dark:bg-slate-800
                   hover:bg-[#d7edf0] dark:hover:bg-slate-700
                   transition-all rounded-xl px-5 py-4
                   border border-[#cae6ea] dark:border-slate-700
                   hover:shadow-md"
          >
            <div class="flex items-center justify-between">
              <span class="text-[#165C75] dark:text-cyan-300 font-semibold text-lg">
                {{ item.question }}
              </span>

              <svg
                :class="[
                  'w-6 h-6 text-[#165C75] dark:text-cyan-300 transition-transform',
                  activeItems[index] ? 'rotate-180' : ''
                ]"
                viewBox="0 0 20 20"
                fill="currentColor"
              >
                <path
                  fill-rule="evenodd"
                  d="M5.23 7.21a.75.75 0 011.06.02L10 10.94l3.71-3.71a.75.75 0 111.06 1.06l-4.24 4.24a.75.75 0 01-1.06 0L5.21 8.29a.75.75 0 01.02-1.08z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
          </div>

          <!-- الجواب -->
          <div
            class="overflow-hidden transition-[max-height] duration-500 ease-in-out"
            :style="activeItems[index] ? 'max-height: 1000px;' : 'max-height: 0px;'"
          >
            <div
              class="bg-[#F7FCFD] dark:bg-slate-800
                     rounded-xl px-5 py-4 mt-2
                     border border-[#D6E8EB] dark:border-slate-700"
            >
              <div class="text-slate-700 dark:text-slate-100 leading-7 text-[16px] whitespace-pre-line">
                {{ item.answer }}
              </div>
              
              <!-- Last updated (optional) -->
              <div v-if="item.updated_at" class="mt-4 pt-4 border-t border-[#D6E8EB] dark:border-slate-700">
                <span class="text-sm text-slate-500 dark:text-slate-400">
                  آخر تحديث: {{ formatDate(item.updated_at) }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- No search results -->
      <div v-if="searchQuery && filteredItems.length === 0" class="text-center py-8">
        <div class="text-gray-500 mb-2">لم يتم العثور على أسئلة مطابقة للبحث</div>
        <button 
          @click="searchQuery = ''"
          class="text-[#165C75] dark:text-cyan-300 hover:underline"
        >
          عرض كل الأسئلة
        </button>
      </div>
      
      <!-- Expand/Collapse all buttons -->
      <div v-if="faqItems.length > 0" class="flex justify-center gap-4 mt-8 pt-8 border-t border-[#E5EDF0] dark:border-slate-700">
        <button
          @click="expandAll"
          class="px-4 py-2 text-sm bg-[#165C75] text-white rounded-lg hover:bg-[#134c5f] transition-colors"
        >
          فتح الكل
        </button>
        <button
          @click="collapseAll"
          class="px-4 py-2 text-sm bg-gray-200 dark:bg-slate-700 text-slate-700 dark:text-slate-300 rounded-lg hover:bg-gray-300 dark:hover:bg-slate-600 transition-colors"
        >
          إغلاق الكل
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { RouterLink } from 'vue-router'

// Reactive data
const pageData = ref({
  page_title: '',
  page_description: ''
})
const faqItems = ref([])
const loading = ref(true)
const error = ref(null)
const activeItems = ref({})
const searchQuery = ref('')

// Fetch FAQ content from API
async function fetchFAQContent() {
  try {
    loading.value = true
    error.value = null
    
    // Use your Laravel API endpoint
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    
    // Try the FAQ endpoint
    const response = await fetch(`${API_URL}/faq-content`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('Fetched FAQ content:', result)
    
    if (result.success && result.data) {
      pageData.value = {
        page_title: result.data.page_title,
        page_description: result.data.page_description
      }
      faqItems.value = result.data.faq_items || []
      
      // Reset active items
      activeItems.value = {}
      
      // Log for debugging
      console.log('FAQ items loaded:', faqItems.value.length)
    } else {
      // Try alternative endpoint
      await fetchFAQAlternative()
    }
  } catch (err) {
    error.value = err.message
    console.error('Error fetching FAQ content:', err)
    
    // Fallback to static data
    faqItems.value = getStaticFAQ()
    pageData.value = {
      page_title: 'الأسئلة الشائعة',
      page_description: 'هنا تجد إجابات لأكثر الأسئلة شيوعًا حول خدمات وبرامج الهيئة العامة لتنمية المشاريع الصغيرة والأصغر.'
    }
  } finally {
    loading.value = false
  }
}

// Alternative FAQ endpoint
async function fetchFAQAlternative() {
  try {
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    const response = await fetch(`${API_URL}/faq-items`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    
    if (result.success && result.data) {
      pageData.value = {
        page_title: result.data.page_title,
        page_description: result.data.page_description
      }
      faqItems.value = result.data.faq_items || []
    } else {
      throw new Error(result.message || 'Failed to fetch FAQ items')
    }
  } catch (err) {
    throw err // Re-throw to be caught by parent function
  }
}

// Static FAQ data for fallback
function getStaticFAQ() {
  return [
    { 
      id: 1, 
      question: 'هل الهيئة تمول؟', 
      answer: 'نعم، الهيئة تقدم قروض بيضاء عبر الجمعيات الشريكة لها في المحافظات لأصحاب المشاريع الصغيرة في مجالات الثروة الحيواني، الصيد البحري، التربية الحيوانية التصنيع الغذائي، الخياطة، الحرف، التصنيع المنزلي.' 
    },
    { 
      id: 2, 
      question: 'كيف تخدمون المشاريع الصغيرة؟', 
      answer: 'تقدم الهيئة العامة لتنمية المشاريع الصغيرة والأصغر الدعم لقطاع المشاريع الصغيرة في اليمن والذي يضم آلاف المشاريع عبر عدة مستويات منها المساهمة في سن القوانيين التي توفر البيئة الداعمة لنمو وتطور المشاريع الصغيرة مثل قانون الاعفاء الضريبي للمشاريع الصغيرة وقانون الاستثمار الذي يعفي المشاريع التي تقل تكلفتها الاستثمارية عن 100 الف دولار من الرسوم الحكومية.' 
    },
    { 
      id: 3, 
      question: 'كيف أقدم على برامج الهيئة التدريبية؟', 
      answer: 'عبر متابعة إعلانات الهيئة عن الدورات التدريبية الجديدة في موقعها الإلكتروني ومنصات مواقع التواصل، الى جانب التسجيل في نموذج الراغبين بخدمة التدريب الموجودة في قسم خدمات التدريب' 
    },
    { 
      id: 4, 
      question: 'كيف أقدم على قرض؟', 
      answer: 'يمكن التقديم على قرض الى الجمعيات الشريكة للهيئة في المديريات المذكورة في قسم خدمات التمويل' 
    },
    { 
      id: 5, 
      question: 'ما نوع التمويل المقدم من الهيئة؟', 
      answer: 'قروض بيضاء ميسرة' 
    }
  ]
}

// Filter FAQ items based on search query
const filteredItems = computed(() => {
  if (!searchQuery.value.trim()) {
    return faqItems.value
  }
  
  const query = searchQuery.value.trim().toLowerCase()
  return faqItems.value.filter(item => 
    item.question.toLowerCase().includes(query) || 
    item.answer.toLowerCase().includes(query)
  )
})

// Toggle FAQ item
const toggle = (index) => {
  activeItems.value[index] = !activeItems.value[index]
}

// Expand all FAQ items
const expandAll = () => {
  faqItems.value.forEach((_, index) => {
    activeItems.value[index] = true
  })
}

// Collapse all FAQ items
const collapseAll = () => {
  activeItems.value = {}
}

// Format date
const formatDate = (dateString) => {
  if (!dateString) return ''
  
  try {
    const date = new Date(dateString)
    return date.toLocaleDateString('ar-SA', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })
  } catch (error) {
    return dateString
  }
}

// Fetch data when component mounts
onMounted(() => {
  fetchFAQContent()
})
</script>

<style scoped>
/* Custom styles if needed */
.whitespace-pre-line {
  white-space: pre-line;
}

/* Smooth transition for FAQ items */
.faq-enter-active,
.faq-leave-active {
  transition: all 0.3s ease;
}

.faq-enter-from,
.faq-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}
</style>