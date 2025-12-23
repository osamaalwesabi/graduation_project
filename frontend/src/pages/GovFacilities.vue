<template>
  <div class="mx-auto max-w-[1300px] px-4 mt-12 pb-20" dir="rtl">
    <!-- Loading State -->
    <div v-if="loading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-[#165C75]"></div>
      <p class="mt-4 text-slate-600 dark:text-slate-300">جاري تحميل التسهيلات الحكومية...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
      <div class="text-red-500 mb-4">⚠️ حدث خطأ في تحميل التسهيلات الحكومية</div>
      <p class="text-slate-600 dark:text-slate-300">{{ error }}</p>
      <button 
        @click="fetchGovernmentFacilities"
        class="mt-4 px-6 py-2 bg-[#165C75] text-white rounded-lg hover:bg-[#124a5d] transition-colors"
      >
        إعادة المحاولة
      </button>
    </div>

    <!-- Main Content -->
    <div v-else>
      <!-- Breadcrumb -->
      <div class="mx-auto max-w-[1300px] px-4 mt-6 mb-4">
        <nav
          class="text-slate-500 dark:text-slate-400 text-sm flex items-center gap-2"
        >
          <RouterLink
            to="/"
            class="hover:text-[#000000] dark:hover:text-cyan-300"
          >
            الرئيسية
          </RouterLink>
          <span>›</span>
          <span class="text-[#000000] dark:text-cyan-300 font-semibold">
            {{ pageTitle || 'التسهيلات الحكومية' }}
          </span>
        </nav>
      </div>

      <!-- Page Title -->
      <div class="mx-auto max-w-[1300px] px-4 mb-6">
        <h1
          class="text-3xl font-bold text-[#000000] dark:text-cyan-300 mb-2 text-right"
        >
          {{ pageTitle || 'التسهيلات الحكومية' }}
        </h1>

        <p
          class="text-slate-600 dark:text-slate-300 text-lg leading-8 w-full md:w-[85%] text-right"
        >
          {{ pageDescription || 'نوفر لك دليلاً شاملاً للتسهيلات والخدمات الحكومية التي تساعد رواد الأعمال وأصحاب المشاريع الصغيرة والأصغر على الانطلاق والنمو بسهولة، مع شرح مبسط للإجراءات والمتطلبات.' }}
        </p>
      </div>

      <!-- Facilities List -->
      <div v-if="facilities && facilities.length > 0">
        <!-- الكارد الأبيض الموحد -->
        <div
          class="mx-auto max-w-[1300px]
                 bg-white dark:bg-slate-900
                 rounded-[40px]
                 border border-[#E5EDF0] dark:border-slate-700
                 shadow-sm p-8 md:p-10"
        >
          <div class="grid gap-8">
            <!-- كارد التسهيلات السماوي -->
            <div
              v-for="(facility, index) in facilities"
              :key="facility.id || index"
              class="gov-card bg-[#E9F5F6] dark:bg-slate-800
                     border border-[#D8EDEE] dark:border-slate-700
                     rounded-[24px]
                     p-6 md:p-8
                     w-full flex flex-col gap-4"
            >
              <!-- هيدر الكارد -->
              <div class="flex items-center gap-3 mb-2">
                <img
                  src="@/assets/icons/gov-icon.png"
                  :alt="facility.title"
                  class="w-9 h-9 object-contain"
                />
                <h2 class="text-xl md:text-2xl font-bold text-[#165C75] dark:text-cyan-300">
                  {{ facility.title }}
                </h2>
              </div>

              <!-- النص -->
              <p class="text-slate-700 dark:text-slate-100 leading-8 text-[16px] md:text-[17px]">
                {{ facility.description }}
              </p>

              <!-- زر اطلب الخدمة -->
              <div class="mt-4 flex justify-center">
                <button
                  @click="goToFacilityForm(facility)"
                  type="button"
                  class="btn-long-full"
                >
                  اطلب الخدمة
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- No Facilities State -->
      <div v-else class="text-center py-12">
        <div class="mx-auto max-w-[1300px] bg-white dark:bg-slate-900 rounded-[40px] border border-[#E5EDF0] dark:border-slate-700 shadow-sm p-8">
          <p class="text-slate-600 dark:text-slate-300">لا توجد تسهيلات حكومية متاحة حالياً</p>
          <button 
            @click="fetchGovernmentFacilities"
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
import { RouterLink, useRouter } from 'vue-router'
import { useAuth } from '@/composables/useAuth'
import { ref, onMounted } from 'vue'

const router = useRouter()
const { isLoggedIn } = useAuth()

const loading = ref(true)
const error = ref(null)
const pageTitle = ref('')
const pageDescription = ref('')
const facilities = ref([])

// Fetch government facilities from API
async function fetchGovernmentFacilities() {
  try {
    loading.value = true
    error.value = null
    
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    const response = await fetch(`${API_URL}/government-facilities-content`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('Fetched government facilities data:', result)
    
    if (result.success && result.data) {
      pageTitle.value = result.data.page_title
      pageDescription.value = result.data.page_description
      facilities.value = result.data.facilities || []
    } else {
      // Fallback to static data
      await fetchStaticFacilities()
    }
  } catch (err) {
    error.value = err.message
    console.error('Error fetching government facilities:', err)
    
    // Fallback to static data
    await fetchStaticFacilities()
  } finally {
    loading.value = false
  }
}

// Fallback static data function
async function fetchStaticFacilities() {
  console.log('Using static government facilities data')
  pageTitle.value = 'التسهيلات الحكومية'
  pageDescription.value = 'نوفر لك دليلاً شاملاً للتسهيلات والخدمات الحكومية التي تساعد رواد الأعمال وأصحاب المشاريع الصغيرة والأصغر على الانطلاق والنمو بسهولة، مع شرح مبسط للإجراءات والمتطلبات.'
  
  facilities.value = [
    {
      id: 1,
      title: 'مذكرة المواصفات والمقاييس',
      description: 'تصدر الهيئة العامة لتنمية المشاريع الصغيرة والأصغر مذكرات رسمية موجهة إلى الجهات الحكومية ذات العلاقة، ومنها الهيئة اليمنية للمواصفات والمقاييس وضبط الجودة، وذلك لتسهيل إجراءات تسجيل وترخيص المشاريع الصغيرة والأصغر، وتمكينها من الحصول على الدعم اللوجستي والخدمات وفق الأنظمة المعتمدة. تمثل هذه المذكرات أداة هامة لدعم رواد الأعمال وتعزيز استدامة المشاريع الإنتاجية الصغيرة.',
      page_slug: 'مذكرة المواصفات والمقاييس',
      form_slug: 'specs-memo-request',
      type: 'government_facility'
    }
  ]
}

// Navigate to facility form
function goToFacilityForm(facility) {
  const formSlug = facility.form_slug || 'specs-memo-request'
  const target = `/form/${formSlug}`

  if (!isLoggedIn.value) {
    router.push({
      name: 'login',
      query: { 
        redirect: target,
        facility: facility.title 
      },
    })
  } else {
    router.push(target)
  }
}

// Original function for backward compatibility
const goToSpecsForm = () => {
  const target = '/form/specs-memo-request'

  if (!isLoggedIn.value) {
    router.push({
      name: 'login',
      query: { 
        redirect: target,
        facility: 'مذكرة المواصفات والمقاييس' 
      },
    })
  } else {
    router.push(target)
  }
}

// Fetch data when component mounts
onMounted(() => {
  fetchGovernmentFacilities()
})
</script>

<style scoped>
.gov-card {
  transition:
    transform .35s cubic-bezier(.2,.9,.3,1),
    box-shadow .35s ease,
    border-color .35s ease,
    background-color .35s ease;
  box-shadow: 0 8px 22px rgba(15,76,92,0.10);
}

.gov-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 22px 40px rgba(15,76,92,0.18);
  border-color: #C7E4E7;
}

/* Button styling */
.btn-long-full {
  background-color: #06A6C8;
  color: white;
  border: none;
  border-radius: 12px;
  padding: 14px 32px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  width: 100%;
  max-width: 280px;
}

.btn-long-full:hover {
  background-color: #124a5d;
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(22, 92, 117, 0.3);
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