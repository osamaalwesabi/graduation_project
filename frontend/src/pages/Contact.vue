<template>
  <div class="mx-auto mt-12 max-w-[1300px] px-4 pb-20" dir="rtl">
    <!-- Loading State -->
    <div v-if="loading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-t-2 border-b-2 border-[#165C75]"></div>
      <p class="mt-4 text-slate-600 dark:text-slate-300">جاري تحميل معلومات التواصل...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
      <div class="text-red-500 mb-4">⚠️ حدث خطأ في تحميل معلومات التواصل</div>
      <p class="text-slate-600 dark:text-slate-300">{{ error }}</p>
      <button 
        @click="fetchContactData"
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
        <RouterLink to="/about" class="hover:text-[#165C75] dark:hover:text-cyan-300">
          عن الهيئة
        </RouterLink>
        <span>›</span>
        <span class="text-[#000000] dark:text-cyan-300 font-semibold">
          {{ pageTitle || 'تواصل معنا' }}
        </span>
      </nav>

      <!-- العنوان + الوصف -->
      <div class="mx-auto max-w-[1300px] px-4 mb-6">
        <h1
          class="text-3xl font-bold text-[#000000] dark:text-cyan-300 mb-3 text-right"
        >
          {{ pageTitle || 'تواصل معنا' }}
        </h1>

        <p
          class="text-gray-600 dark:text-slate-300 mb-8 leading-relaxed max-w-[850px] text-right"
        >
          {{ pageDescription || 'نحن هنا لدعمك والإجابة على استفساراتك حول المشاريع الصغيرة والأصغر. يسعدنا التواصل معك في حال كان لديك سؤال أو اقتراح.' }}
        </p>
      </div>

      <!-- الكارد الأبيض -->
      <div
        class="mx-auto max-w-[1300px] bg-white dark:bg-slate-900 rounded-[40px]
               border border-[#E5EDF0] dark:border-slate-700 shadow-sm
               px-6 md:px-10 py-10"
      >
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
          <!-- اتصل بنا -->
          <div v-if="sections.contact_phone" class="box hover-card">
            <div class="icon-box ml-auto">
              <img :src="iconPhone" class="icon" />
            </div>
            <h3 class="title">{{ sections.contact_phone.title }}</h3>
            <p class="text whitespace-pre-line">
              {{ formatContactText(sections.contact_phone.description) }}
            </p>
          </div>

          <!-- نموذج تواصل -->
          <div v-if="sections.contact_form" class="box hover-card flex flex-col justify-between">
            <div class="flex flex-col text-right">
              <div class="icon-box ml-auto">
                <img :src="iconForm" class="icon" />
              </div>
              <h3 class="title">
                {{ sections.contact_form.title }}
              </h3>
              <p class="text whitespace-pre-line">
                {{ formatContactText(sections.contact_form.description) }}
              </p>
            </div>

            <!-- الزر الأخضر بالسهم في الشق الثاني (يمين) -->
            <div class="mt-4 flex justify-end">
              <RouterLink
                :to="{ name: 'dynamic-form', params: { slug: 'contact-form' } }"
                class="arrow-btn"
                aria-label="فتح نموذج التواصل"
              >
                <svg class="w-6 h-6" viewBox="0 0 24 24" fill="none">
                  <path
                    d="M16 12H5M10 7l-5 5 5 5"
                    stroke="white"
                    stroke-width="2"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                  />
                </svg>
              </RouterLink>
            </div>
          </div>

          <!-- العنوان -->
          <div v-if="sections.address" class="box hover-card">
            <div class="icon-box ml-auto">
              <img :src="iconLocation" class="icon" />
            </div>
            <h3 class="title">{{ sections.address.title }}</h3>
            <p class="text whitespace-pre-line">
              {{ formatContactText(sections.address.description) }}
            </p>
          </div>

          <!-- السوشال -->
          <div v-if="sections.social_media" class="box hover-card">
            <div class="icon-box ml-auto">
              <img :src="iconSocial" class="icon" />
            </div>

            <h3 class="title">{{ sections.social_media.title }}</h3>

            <p class="text mb-3" v-if="sections.social_media.description">
              {{ sections.social_media.description }}
            </p>

            <div class="flex gap-3 justify-end">
              <!-- Facebook -->
              <a
                v-if="hasSocialLink('facebook')"
                :href="getSocialLink('facebook')"
                target="_blank"
                rel="noopener"
                class="soc"
                aria-label="Facebook"
              >
                <img src="@/assets/icons/facebook.png" alt="Facebook" class="w-6 h-6" />
              </a>

              <!-- Telegram -->
              <a
                v-if="hasSocialLink('telegram')"
                :href="getSocialLink('telegram')"
                target="_blank"
                rel="noopener"
                class="soc"
                aria-label="Telegram"
              >
                <img src="@/assets/icons/telegram.png" alt="Telegram" class="w-6 h-6" />
              </a>

              <!-- WhatsApp -->
              <a
                v-if="hasSocialLink('whatsapp')"
                :href="getSocialLink('whatsapp')"
                target="_blank"
                rel="noopener"
                class="soc"
                aria-label="WhatsApp"
              >
                <img src="@/assets/icons/whatsapp.png" alt="WhatsApp" class="w-6 h-6" />
              </a>

              <!-- X (Twitter) -->
              <a
                v-if="hasSocialLink('x')"
                :href="getSocialLink('x')"
                target="_blank"
                rel="noopener"
                class="soc"
                aria-label="X"
              >
                <svg viewBox="0 0 24 24" class="w-5 h-5" fill="none">
                  <path
                    d="M4 3h4l4 5 4-5h4l-7 8 7 10h-4l-5-7-5 7H4l7-10z"
                    fill="#000000"
                  />
                </svg>
              </a>

              <!-- YouTube -->
              <a
                v-if="hasSocialLink('youtube')"
                :href="getSocialLink('youtube')"
                target="_blank"
                rel="noopener"
                class="soc"
                aria-label="YouTube"
              >
                <img src="@/assets/icons/youtube.png" alt="YouTube" class="w-6 h-6" />
              </a>
            </div>
          </div>

          <!-- البريد -->
          <div v-if="sections.email" class="box hover-card">
            <div class="icon-box ml-auto">
              <img :src="iconEmail" class="icon" />
            </div>
            <h3 class="title">{{ sections.email.title }}</h3>
            <p class="text">
              {{ formatContactText(sections.email.description) }}
            </p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { RouterLink } from 'vue-router'
import { ref, onMounted } from 'vue'

import iconForm from '@/assets/images/icon4.png'
import iconPhone from '@/assets/images/icon1.png'
import iconLocation from '@/assets/images/icon5.png'
import iconSocial from '@/assets/images/icon2.png'
import iconEmail from '@/assets/images/icon3.png'

const loading = ref(true)
const error = ref(null)
const pageTitle = ref('')
const pageDescription = ref('')
const sections = ref({})

// Fetch contact data from API
async function fetchContactData() {
  try {
    loading.value = true
    error.value = null
    
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    const response = await fetch(`${API_URL}/contact-content`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('Fetched contact data:', result)
    
    if (result.success && result.data) {
      pageTitle.value = result.data.page_title
      pageDescription.value = result.data.page_description
      sections.value = result.data.sections || {}
    } else {
      // Fallback to static data
      await fetchStaticContactData()
    }
  } catch (err) {
    error.value = err.message
    console.error('Error fetching contact data:', err)
    
    // Fallback to static data
    await fetchStaticContactData()
  } finally {
    loading.value = false
  }
}

// Fallback static data function
async function fetchStaticContactData() {
  console.log('Using static contact data')
  pageTitle.value = 'تواصل معنا'
  pageDescription.value = 'نحن هنا لدعمك والإجابة على استفساراتك حول المشاريع الصغيرة والأصغر. يسعدنا التواصل معك في حال كان لديك سؤال أو اقتراح.'
  
  sections.value = {
    contact_phone: {
      title: 'اتصل بنا',
      description: "780040072 :رقم العلاقات العامة\n780040073 :رقم الإعلام\n783888781 :نافذة المقترحات",
      type: 'phone'
    },
    contact_form: {
      title: 'نموذج تواصل',
      description: "السبت – الأربعاء\n8:00 صباحًا – 1:00 مساءً",
      type: 'form'
    },
    address: {
      title: 'العنوان',
      description: "صنعاء – الدائري – جولة غزة (كنتاكي سابقاً)\nعمارة المعتلي",
      type: 'address'
    },
    social_media: {
      title: 'وسائل التواصل الاجتماعي',
      description: "حساباتنا الرسمية على مواقع التواصل",
      social_links: [
        { platform: 'facebook', url: 'https://www.facebook.com/share/1Lk2sKUtik/' },
        { platform: 'telegram', url: 'https://t.me/samea777' },
        { platform: 'whatsapp', url: 'https://wa.me/967780040073' },
        { platform: 'x', url: 'https://x.com/Gasmed28Gasmed?t=MTnUmxS6FGUDzKghkLtP9A&s=09' },
        { platform: 'youtube', url: 'https://youtube.com/channel/UCL-scONsm7whLMk2rc1aCaA?si=AJ-dMnJlO-RLQKGQ' }
      ],
      type: 'social'
    },
    email: {
      title: 'البريد الإلكتروني',
      description: 'info@gasmed.gov.ye',
      type: 'email'
    }
  }
}

// Format contact text to handle line breaks
function formatContactText(text) {
  if (!text) return ''
  return text.replace(/\\n/g, '\n')
}

// Check if a social media link exists
function hasSocialLink(platform) {
  if (!sections.value.social_media || !sections.value.social_media.social_links) {
    return false
  }
  return sections.value.social_media.social_links.some(link => link.platform === platform)
}

// Get social media link by platform
function getSocialLink(platform) {
  if (!sections.value.social_media || !sections.value.social_media.social_links) {
    return null
  }
  const link = sections.value.social_media.social_links.find(l => l.platform === platform)
  return link ? link.url : null
}

// Fetch data when component mounts
onMounted(() => {
  fetchContactData()
})
</script>

<style scoped>
.box {
  @apply bg-[#ECF6F7] dark:bg-slate-800 rounded-3xl p-6 text-right
         shadow border border-[#D8EDEE] dark:border-slate-700
         transition-all duration-300;
}

/* هوفر موحّد مع بقية الكروت */
.hover-card {
  transition:
    transform .35s cubic-bezier(.2,.9,.3,1),
    box-shadow .35s ease,
    border-color .35s ease,
    background-color .35s ease;
  box-shadow: 0 8px 22px rgba(15,76,92,0.10);
}
.hover-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 20px 36px rgba(15,76,92,0.18);
  border-color: #C7E4E7;
}
.hover-card:active {
  transform: scale(0.97);
}

.icon-box {
  @apply w-14 h-14 rounded-full bg-white flex items-center justify-center mb-4;
}
.icon {
  @apply w-7 h-7;
}
.title {
  @apply text-xl font-bold text-[#165C75] dark:text-cyan-300 mb-2;
}
.text {
  @apply text-gray-700 dark:text-slate-200 leading-relaxed;
}

/* زر السهم أسفل الكارد */
.arrow-link {
  @apply text-[#27AEB9] hover:text-[#165C75] transition-colors;
}

/* دوائر أيقونات السوشال */
.soc {
  @apply inline-flex items-center justify-center
         w-9 h-9 rounded-full
         bg-white/80 hover:bg-white
         border border-white
         text-[#165C75] transition-colors duration-200;
}
.arrow-btn {
  @apply inline-flex items-center justify-center
         px-4 h-10 rounded-2xl
         bg-[#0CA138] hover:bg-[#0a812d]
         text-white transition-colors;
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