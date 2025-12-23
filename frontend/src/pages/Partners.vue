<template>
  <div class="mx-auto max-w-[1300px] px-4 mt-12" dir="rtl">
    <!-- Breadcrumb -->
    <div class="mx-auto max-w-[1300px] px-4 mt-6 mb-4">
      <nav class="text-slate-500 dark:text-slate-400 text-sm flex items-center gap-2">
        <RouterLink to="/" class="hover:text-[#165C75] dark:hover:text-cyan-300">الرئيسية</RouterLink>
        <span>›</span>
        <RouterLink to="/about" class="hover:text-[#165C75] dark:hover:text-cyan-300">عن الهيئة</RouterLink>
        <span>›</span>
        <span class="text-[#000000] dark:text-cyan-300 font-semibold">الشركاء</span>
      </nav>
    </div>

    <!-- Loading State -->
    <div v-if="loading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-[#165C75]"></div>
      <p class="mt-4 text-slate-600 dark:text-slate-300">جاري تحميل البيانات...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
      <div class="text-red-500 mb-4">⚠️ حدث خطأ في تحميل البيانات</div>
      <p class="text-slate-600 dark:text-slate-300">{{ error }}</p>
      <button 
        @click="fetchPartners"
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
          شركاؤنا
        </h1>
      </div>

      <!-- Description -->
      <div class="mx-auto max-w-[1300px] px-4 mb-6">
        <p class="text-right max-w-[900px] ml-auto text-slate-600 dark:text-slate-300 leading-8 text-[17px]">
          نفخر بشراكاتنا الإستراتيجية مع مؤسسات محلية ودولية بارزة، تسهم معنا في دعم المشاريع 
          الصغيرة والأصغر وتعزيز بيئة ريادة الأعمال. وإن تعاوننا مع شركائنا يفتح آفاقاً واسعة
          للإبتكار، ويوفر فرصاً أكبر للنمو والاستدامة، لنصبح معاً نحو مستقبل أكثر إشراقاً.
        </p>
      </div>

      <!-- White Card Wrapper -->
      <div
        v-if="partners && partners.length > 0"
        class="mx-auto max-w-[1300px] bg-white dark:bg-slate-800 rounded-[40px]
               border border-[#E5EDF0] dark:border-slate-700 shadow-sm p-8 md:p-10 mt-4"
      >
        <!-- Cards grid -->
        <div class="w-full grid md:grid-cols-2 gap-8">
          <RouterLink
            v-for="(partner, index) in partners"
            :key="index"
            :to="partner.url"
            class="partner-card bg-[#E6F3F5] dark:bg-slate-700
                   rounded-3xl p-8 border border-[#D6E8EB] dark:border-slate-600
                   shadow-sm block"
          >
            <div class="flex items-center gap-3 mb-4">
              <img src="@/assets/images/hand-icon.png" class="w-12 h-12" />
              <h2 class="text-xl font-bold text-[#165C75] dark:text-cyan-300">
                {{ partner.content }}
              </h2>
            </div>

            <p class="text-slate-600 dark:text-slate-100 leading-8 text-[17px]">
              {{ partner.desc }}
            </p>
          </RouterLink>
        </div>
      </div>

      <!-- No Data State -->
      <div v-else class="text-center py-12">
        <p class="text-slate-600 dark:text-slate-300">لا توجد بيانات للشركاء حالياً</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { RouterLink } from "vue-router";
import { ref, onMounted } from "vue";

const loading = ref(true);
const error = ref(null);
const partners = ref([]);

// Fetch partners from API
async function fetchPartners() {
  try {
    loading.value = true;
    error.value = null;
    
    // Use your Laravel API endpoint
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api';
    
    const response = await fetch(`${API_URL}/partners-content`);
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const result = await response.json();
    console.log('Fetched partners data:', result);
    
    if (result.success && result.data) {
      // Directly use the array from the API response
      partners.value = result.data;
    } else {
      // Fallback to static data if API returns no data
      await fetchStaticPartners();
    }
  } catch (err) {
    error.value = err.message;
    console.error('Error fetching partners:', err);
    
    // Fallback to static data
    await fetchStaticPartners();
  } finally {
    loading.value = false;
  }
}

// Fallback static data function
async function fetchStaticPartners() {
  console.log('Using static partners data');
  partners.value = [
    {
      title: "الشركاء المنفذون",
      link: "/partners/executors",
      desc: "شركاؤنا المنفذون هم الذراع التنفيذية التي حولت الرؤى إلى واقع ملموس من خلال شراكات استراتيجية مبنية على الثقة والكفاءة."
    },
    {
      title: "الشركاء الممولون",
      link: "/partners/funders",
      desc: "نعتز بشركائنا الممولين الذين أسهموا في دعم وتمويل البرامج والمشاريع التنموية التي تخدم المجتمع وتدعم الاقتصاد المحلي."
    }
  ];
}

// Fetch data when component mounts
onMounted(() => {
  fetchPartners();
});
</script>

<style scoped>
.partner-card {
  transition:
    transform .35s cubic-bezier(.2,.9,.3,1),
    box-shadow .35s ease,
    border-color .35s ease,
    background-color .35s ease;
  box-shadow: 0 8px 22px rgba(15,76,92,0.10);
}

.partner-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 20px 36px rgba(15,76,92,0.18);
  border-color: #C7E4E7;
}

/* Loading spinner animation */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
</style>