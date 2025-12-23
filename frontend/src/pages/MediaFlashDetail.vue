<template>
  <div class="mx-auto max-w-[1300px] px-4 mt-12 pb-20" dir="rtl">
    <!-- Breadcrumb -->
    <nav class="text-slate-500 dark:text-slate-400 text-sm flex items-center gap-2 mb-6">
      <RouterLink to="/" class="hover:text-[#165C75] dark:hover:text-cyan-300">
        الرئيسية
      </RouterLink>
      <span>›</span>
      <RouterLink to="/media" class="hover:text-[#165C75] dark:hover:text-cyan-300">
        قسم الإعلام والتوعية
      </RouterLink>
      <span>›</span>
      <RouterLink :to="`/media/flashes/${video.category}`" class="hover:text-[#165C75] dark:hover:text-cyan-300">
        {{ video.category_name }}
      </RouterLink>
      <span>›</span>
      <span class="text-[#000000] dark:text-cyan-300 font-semibold">
        {{ video.title }}
      </span>
    </nav>

    <!-- Video Container -->
    <div class="bg-white dark:bg-slate-900 rounded-[40px] border border-[#E5EDF0] dark:border-slate-700 shadow-sm p-6 md:p-8">
      <!-- Video Title -->
      <h1 class="text-2xl md:text-3xl font-bold text-[#000000] dark:text-cyan-300 mb-6 text-right">
        {{ video.title }}
      </h1>
      
      <!-- Video Player -->
      <div class="mb-6">
        <div class="relative rounded-2xl overflow-hidden bg-black">
          <video 
            v-if="video.video_url"
            :src="video.video_url"
            controls
            class="w-full h-auto max-h-[600px]"
            :poster="video.thumbnail"
          >
            متصفحك لا يدعم تشغيل الفيديو.
          </video>
          <div v-else class="aspect-video flex items-center justify-center bg-gray-800">
            <p class="text-white">رابط الفيديو غير متوفر</p>
          </div>
        </div>
      </div>
      
      <!-- Video Info -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div class="text-center p-4 bg-[#E9F5F6] dark:bg-slate-800 rounded-xl">
          <p class="text-sm text-slate-500 dark:text-slate-400 mb-1">المدة</p>
          <p class="text-lg font-semibold text-[#165C75] dark:text-cyan-300">{{ video.duration }}</p>
        </div>
        <div class="text-center p-4 bg-[#E9F5F6] dark:bg-slate-800 rounded-xl">
          <p class="text-sm text-slate-500 dark:text-slate-400 mb-1">المشاهدات</p>
          <p class="text-lg font-semibold text-[#165C75] dark:text-cyan-300">{{ formatNumber(video.views) }}</p>
        </div>
        <div class="text-center p-4 bg-[#E9F5F6] dark:bg-slate-800 rounded-xl">
          <p class="text-sm text-slate-500 dark:text-slate-400 mb-1">تاريخ النشر</p>
          <p class="text-lg font-semibold text-[#165C75] dark:text-cyan-300">{{ formatDate(video.created_at) }}</p>
        </div>
      </div>
      
      <!-- Video Description -->
      <div class="mb-8">
        <h2 class="text-xl font-bold text-[#000000] dark:text-cyan-300 mb-4 text-right">وصف الفيديو</h2>
        <p class="text-slate-600 dark:text-slate-300 leading-8 text-[16px] text-right">
          {{ video.description }}
        </p>
      </div>
      
      <!-- Navigation Between Videos -->
      <div class="flex justify-between items-center border-t border-[#E5EDF0] dark:border-slate-700 pt-6">
        <!-- Previous Video -->
        <RouterLink
          v-if="video.prev_video"
          :to="`/media/flashes/${video.category}/${video.prev_video.slug}`"
          class="flex items-center gap-3 px-4 py-2 bg-[#E9F5F6] dark:bg-slate-800 rounded-xl hover:bg-[#D8EDEE] dark:hover:bg-slate-700 transition-colors"
        >
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/>
          </svg>
          <div class="text-right">
            <p class="text-sm text-slate-500 dark:text-slate-400">السابق</p>
            <p class="font-medium text-[#165C75] dark:text-cyan-300">{{ video.prev_video.title }}</p>
          </div>
        </RouterLink>
        <div v-else></div>
        
        <!-- Back to Category -->
        <RouterLink
          :to="`/media/flashes/${video.category}`"
          class="px-6 py-2 bg-[#165C75] text-white rounded-xl hover:bg-[#124a5d] transition-colors"
        >
          العودة إلى القائمة
        </RouterLink>
        
        <!-- Next Video -->
        <RouterLink
          v-if="video.next_video"
          :to="`/media/flashes/${video.category}/${video.next_video.slug}`"
          class="flex items-center gap-3 px-4 py-2 bg-[#E9F5F6] dark:bg-slate-800 rounded-xl hover:bg-[#D8EDEE] dark:hover:bg-slate-700 transition-colors"
        >
          <div class="text-right">
            <p class="text-sm text-slate-500 dark:text-slate-400">التالي</p>
            <p class="font-medium text-[#165C75] dark:text-cyan-300">{{ video.next_video.title }}</p>
          </div>
          <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
          </svg>
        </RouterLink>
        <div v-else></div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { RouterLink } from 'vue-router'

const props = defineProps({
  video: {
    type: Object,
    required: true
  }
})

// Format number with commas
function formatNumber(num) {
  return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}

// Format date
function formatDate(dateString) {
  const date = new Date(dateString);
  return date.toLocaleDateString('ar-EG', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
}
</script>