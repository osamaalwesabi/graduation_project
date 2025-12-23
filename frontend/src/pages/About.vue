<template>
  <div class="mx-auto mt-12 max-w-[1300px] px-4 pb-20" dir="rtl">
    <!-- 🧭 Breadcrumb -->
    <nav
      class="mx-auto max-w-[1300px] px-4 text-slate-500 dark:text-slate-400 text-sm
             flex items-center gap-2 mb-4"
    >
      <RouterLink
        to="/"
        class="hover:text-[#165C75] dark:hover:text-[#7BD4FF]"
      >
        الرئيسية
      </RouterLink>
      <span>›</span>
      <RouterLink
        to="/about"
        class="hover:text-[#165C75] dark:hover:text-[#7BD4FF]"
      >
        عن الهيئة
      </RouterLink>
      <span>›</span>
      <span class="text-[#000000] dark:text-cyan-300 font-semibold">
        {{ pageData.page_title || 'من نحن' }}
      </span>
    </nav>

    <!-- 🟦 العنوان + الوصف -->
    <div class="mx-auto max-w-[1300px] px-4 mb-6">
      <h1
        class="text-3xl font-bold text-[#000000] dark:text-cyan-300 mb-3 text-right"
      >
        {{ pageData.page_title || 'من نحن' }}
      </h1>

      <p
        v-if="pageData.page_description"
        class="text-gray-600 dark:text-slate-300 mb-8 leading-relaxed max-w-[850px] text-right"
      >
        {{ pageData.page_description }}
      </p>
      
      <!-- Loading state -->
      <div v-if="loading" class="space-y-4">
        <div class="h-8 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-3/4"></div>
        <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-1/2"></div>
      </div>
    </div>

    <!-- 🟩 الكارد الأبيض -->
    <div
      v-if="!loading && pageData.sections"
      class="mx-auto max-w-[1300px] bg-white dark:bg-slate-900 rounded-[40px]
             border border-[#E5EDF0] dark:border-slate-700 shadow-sm
             px-6 md:px-10 py-10 space-y-10"
    >
      <!-- 🟩 من نحن -->
      <section v-if="pageData.sections.about_us">
        <div
          class="bg-[#E6F4F7] dark:bg-slate-700
                 rounded-3xl p-6 md:p-8
                 border border-[#EAF4F5] dark:border-slate-600"
          dir="rtl"
        >
          <h2
            class="text-xl font-bold text-[#165C75] dark:text-[#7BD4FF]
                   mb-3 flex items-center gap-2"
          >
            <img src="@/assets/images/icon-hex.png" class="w-6 h-6" />
            من نحن
          </h2>
          <p class="text-slate-600 dark:text-slate-100 leading-7 whitespace-pre-line">
            {{ pageData.sections.about_us }}
          </p>
        </div>
      </section>

      <!-- 🟩 الرؤية والرسالة -->
      <section v-if="pageData.sections.vision || pageData.sections.mission" class="grid md:grid-cols-2 gap-6" dir="rtl">
        <!-- الرؤية -->
        <div
          v-if="pageData.sections.vision"
          class="bg-[#E6F4F7] dark:bg-slate-700
                 p-6 rounded-3xl
                 border border-[#EAF4F5] dark:border-slate-600"
        >
          <h3
            class="text-xl font-bold text-[#165C75] dark:text-[#7BD4FF]
                   mb-3 flex items-center gap-2"
          >
            <img src="@/assets/images/icon-hex.png" class="w-6 h-6" />
            الرؤية
          </h3>
          <p class="text-slate-600 dark:text-slate-100 leading-7 whitespace-pre-line">
            {{ pageData.sections.vision }}
          </p>
        </div>

        <!-- الرسالة -->
        <div
          v-if="pageData.sections.mission"
          class="bg-[#E6F4F7] dark:bg-slate-700
                 p-6 rounded-3xl
                 border border-[#D0E7EB] dark:border-slate-600"
        >
          <h3
            class="text-xl font-bold text-[#165C75] dark:text-[#7BD4FF]
                   mb-3 flex items-center gap-2"
          >
            <img src="@/assets/images/icon-hex.png" class="w-6 h-6" />
            الرسالة
          </h3>
          <p class="text-slate-600 dark:text-slate-100 leading-7 whitespace-pre-line">
            {{ pageData.sections.mission }}
          </p>
        </div>
      </section>

      <!-- 🟩 الأهداف -->
      <section v-if="pageData.sections.objectives && pageData.sections.objectives.length > 0">
        <div
          class="bg-[#E6F4F7] dark:bg-slate-700
                 rounded-3xl p-6 md:p-8
                 border border-[#D0E7EB] dark:border-slate-600"
          dir="rtl"
        >
          <h2
            class="text-xl font-bold text-[#165C75] dark:text-[#7BD4FF]
                   mb-4 flex items-center gap-2"
          >
            <img src="@/assets/images/icon-hex.png" class="w-6 h-6" />
            الأهداف
          </h2>
          <ol class="list-decimal pr-4 text-slate-600 dark:text-slate-100 leading-8 space-y-2">
            <li v-for="(objective, index) in pageData.sections.objectives" :key="index">
              {{ objective }}
            </li>
          </ol>
        </div>
      </section>

      <!-- 🟩 قيمنا -->
      <section v-if="pageData.sections.values && pageData.sections.values.length > 0" class="mt-4" dir="rtl">
        <div
          class="bg-[#E9F5F6] dark:bg-slate-700
                 rounded-[32px] px-6 md:px-10 py-8
                 border border-[#D8EDEE] dark:border-slate-600"
        >
          <!-- العنوان داخل الكارد -->
          <h3
            class="text-xl font-bold text-[#165C75] dark:text-[#7BD4FF]
                   mb-6 flex items-center gap-2"
          >
            <img src="@/assets/images/icon-hex.png" class="w-6 h-6" />
            قيمنا
          </h3>

          <!-- شبكة القيم -->
          <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-y-12 gap-x-8">
            <!-- قيمة واحدة -->
            <div 
              v-for="(value, index) in pageData.sections.values" 
              :key="index"
              class="relative px-6 md:px-10 py-6 text-center"
            >
              <img
                src="@/assets/images/value-corner.svg"
                class="absolute right-4 top-3 w-[32px] h-[38px]"
              />
              <img
                src="@/assets/images/value-corner.svg"
                class="absolute left-4 bottom-3 rotate-180 w-[32px] h-[38px]"
              />
              <h3 class="text-[#165C75] dark:text-[#7BD4FF] font-bold text-xl mb-3">
                {{ value.name }}
              </h3>
              <p v-if="value.description" class="text-slate-600 dark:text-slate-100 leading-8 text-[16px] whitespace-pre-line">
                {{ value.description }}
              </p>
            </div>
          </div>
        </div>
      </section>

      <!-- Error message -->
      <div v-if="error" class="text-center py-8">
        <div class="text-red-500 mb-4">حدث خطأ في تحميل البيانات</div>
        <button 
          @click="fetchAboutContent"
          class="px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#134c5f] transition-colors"
        >
          حاول مرة أخرى
        </button>
      </div>
    </div>

    <!-- Empty state -->
    <div v-if="!loading && (!pageData.sections || Object.keys(pageData.sections).length === 0)" 
         class="text-center py-12">
      <div class="text-gray-500 mb-4">لا توجد بيانات متاحة حالياً</div>
      <button 
        @click="fetchAboutContent"
        class="px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#134c5f] transition-colors"
      >
        تحديث الصفحة
      </button>
    </div>

    <!-- Loading skeleton for the main card -->
    <div v-else-if="loading" class="mx-auto max-w-[1300px] space-y-8">
      <div class="bg-white dark:bg-slate-900 rounded-[40px] p-8 space-y-6">
        <div v-for="i in 5" :key="i" class="space-y-3">
          <div class="h-6 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-1/4"></div>
          <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-full"></div>
          <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded animate-pulse w-3/4"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { RouterLink } from 'vue-router'

// Reactive data
const pageData = ref({
  page_title: '',
  page_description: '',
  sections: null
})
const loading = ref(true)
const error = ref(null)

// Fetch about content from API
async function fetchAboutContent() {
  try {
    loading.value = true
    error.value = null
    
    // Use your Laravel API endpoint
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    
    // Try the endpoint
    const response = await fetch(`${API_URL}/about-us-content`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('Fetched about content:', result)
    
    if (result.success && result.data) {
      // Set the entire data object
      pageData.value = result.data
      
      // Debug log to see the structure
      console.log('pageData structure:', {
        page_title: pageData.value.page_title,
        page_description: pageData.value.page_description,
        sections: pageData.value.sections
      })
    } else {
      throw new Error(result.message || 'Failed to fetch about content')
    }
  } catch (err) {
    error.value = err.message
    console.error('Error fetching about content:', err)
    
    // Fallback to default data for testing
    pageData.value = {
      page_title: 'من نحن',
      page_description: 'تعرف على الهيئة العامة لتنمية المشاريع الصغيرة والأصغر، رؤيتها ورسالتها وأهدافها وقيمها التي تخدم رواد الأعمال وأصحاب المشاريع الصغيرة.',
      sections: {
        about_us: 'تأسست الهيئة العامة لتنمية المشاريع الصغيرة والأصغر في مارس 2021 بهدف تنظيم وتنمية قطاع المشاريع الصغيرة...',
        vision: 'مجتمع منتج قادر على توظيف موارده بما يعزز الاقتصاد الوطني.',
        mission: 'تنمية المشاريع الصغيرة والأصغر من خلال توفير البيئة الداعمة ونشر المعرفة وتوظيف الإمكانات المتاحة بطرق مبتكرة ومتكاملة.',
        objectives: [
          'توفير بيئة داعمة تساعد على تنمية المشاريع الصغيرة...',
          'وضع الاستراتيجيات والسياسات الوطنية الداعمة...',
          'نشر المعرفة بما يحقق الفاعلية والاستدامة...',
          'دعم نفاذ منتجات المشاريع الصغيرة...'
        ],
        values: [
          { name: 'النزاهة', description: 'تنفيذ كافة المهام والالتزامات بأمانة وصدق والالتزام بكل ما هو أخلاقي.' },
          { name: 'الشفافية', description: 'الإفصاح عن نتائج العمليات بشكل مستمر ومنتظم وتمكين الجميع من الحصول على المعلومات.' },
          { name: 'المرونة', description: 'القدرة على التكيّف مع المتغيرات لتحقيق أداء مستقر.' },
          { name: 'الشمول', description: 'وصول الخدمات المالية وغير المالية لكل المناطق والمحافظات.' },
          { name: 'التكامل', description: 'توحيد جهود العاملين لتحقيق سلسلة أهداف متكاملة.' },
          { name: 'الابتكار', description: 'تقديم حلول مبتكرة تدعم تطوير المشاريع الصغيرة والأصغر.' }
        ]
      }
    }
  } finally {
    loading.value = false
  }
}

// Fetch data when component mounts
onMounted(() => {
  fetchAboutContent()
})
</script>

<style scoped>
/* Add any custom styles if needed */
.whitespace-pre-line {
  white-space: pre-line;
}
</style>