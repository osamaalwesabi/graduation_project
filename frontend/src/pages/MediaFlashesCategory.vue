<template>
  <FlashesCategoryLayout
    :title="current.title"
    :breadcrumb-label="current.breadcrumbLabel"
    :description="current.description"
    :videos="videos"
    :category-slug="currentSlug"
    :loading="loading"
    :error="error"
  />
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import FlashesCategoryLayout from '@/components/FlashesCategoryLayout.vue'

const route = useRoute()
const loading = ref(true)
const error = ref(null)
const videos = ref([])
const categoryInfo = ref({})

const currentSlug = computed(() => route.params.slug || 'home-industry')

// Fetch videos from API
async function fetchVideos() {
  try {
    loading.value = true
    error.value = null
    
    const API_URL = import.meta.env.VITE_API_URL || 'http://127.0.0.1:8000/api'
    const response = await fetch(`${API_URL}/flash-videos/${currentSlug.value}`)
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    console.log('Fetched videos data:', result)
    
    if (result.success && result.data) {
      categoryInfo.value = result.data.category
      videos.value = result.data.videos || []
    } else {
      // Fallback to static data
      await fetchStaticVideos()
    }
  } catch (err) {
    error.value = err.message
    console.error('Error fetching videos:', err)
    
    // Fallback to static data
    await fetchStaticVideos()
  } finally {
    loading.value = false
  }
}

// Fallback static data
async function fetchStaticVideos() {
  console.log('Using static videos data')
  
  const STATIC_CATEGORIES = {
    'home-industry': {
      breadcrumbLabel: 'فيديوهات توعوية (الصناعات المنزلية)',
      title: 'فيديوهات توعوية (الصناعات المنزلية)',
      description: 'مجموعة فيديوهات توضح خطوات الصناعات الغذائية المنزلية بطريقة آمنة وسهلة.',
      videos: [
        { id: 1, slug: 'cream-cheese', title: 'إنتاج الجبن السائل (الكريمي) في البيت', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 2, slug: 'salty-cheese', title: 'إنتاج الجبن المالح في البيت', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 3, slug: 'milk-powder', title: 'إنتاج الزبادي من الحليب البودرة في المنزل', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 4, slug: 'apple-jam', title: 'إنتاج مربى التفاح الطبيعي في البيت', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 5, slug: 'strawberry-jam', title: 'إنتاج مربى الفراولة الطبيعي في البيت', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 6, slug: 'dry-tomato', title: 'تجفيف الطماطم خلال مواسم الوفرة', thumbnail: '/assets/images/home-vid-1.png' },
      ]
    },
    'animal-health': {
      breadcrumbLabel: 'فلاشات توعوية (الصحة الحيوانية)',
      title: 'فلاشات توعوية (الصحة الحيوانية)',
      description: 'مواد مرئية توعوية للحفاظ على صحة المواشي وتحسين الإنتاج.',
      videos: [
        { id: 1, slug: 'msg-1', title: 'رسالة توعوية لمربي المواشي 1', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 2, slug: 'msg-2', title: 'رسالة توعوية لمربي المواشي 2', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 3, slug: 'msg-3', title: 'رسالة توعوية لمربي المواشي 3', thumbnail: '/assets/images/home-vid-1.png' },
      ]
    },
    'learn-in-a-minute': {
      breadcrumbLabel: 'سلسلة تعلّم في دقيقة',
      title: 'سلسلة تعلّم في دقيقة',
      description: 'فيديوهات سريعة تسلط الضوء على مهارات ونصائح لأصحاب المشاريع الصغيرة.',
      videos: [
        { id: 1, slug: 'skill-1', title: 'مهارة 1', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 2, slug: 'skill-2', title: 'مهارة 2', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 3, slug: 'skill-3', title: 'مهارة 3', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 4, slug: 'skill-4', title: 'مهارة 4', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 5, slug: 'skill-5', title: 'مهارة 5', thumbnail: '/assets/images/home-vid-1.png' },
        { id: 6, slug: 'skill-6', title: 'مهارة 6', thumbnail: '/assets/images/home-vid-1.png' },
      ]
    }
  }
  
  const defaultCategory = STATIC_CATEGORIES[currentSlug.value] || STATIC_CATEGORIES['home-industry']
  categoryInfo.value = {
    breadcrumbLabel: defaultCategory.breadcrumbLabel,
    title: defaultCategory.title,
    description: defaultCategory.description
  }
  videos.value = defaultCategory.videos
}

const current = computed(() => ({
  title: categoryInfo.value.title || 'الفلاشات التوعوية',
  breadcrumbLabel: categoryInfo.value.breadcrumbLabel || 'الفلاشات التوعوية',
  description: categoryInfo.value.description || ''
}))

// Fetch data when component mounts or slug changes
onMounted(() => {
  fetchVideos()
})
</script>