<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Models\Page;
use App\Models\Content;
use App\Models\ContentInfo;
use App\Models\ContentDetail;

Route::middleware(['auth:sanctum'])->get('/user', function (Request $request) {
    return $request->user();
});
// routes/api.php
use App\Http\Controllers\Api\Website\PageController;
use App\Http\Controllers\Api\Website\ContentController;

Route::prefix('website')->group(function () {
    // Pages
    Route::get('pages', [PageController::class, 'index']);
    Route::get('pages/{id}', [PageController::class, 'show']);
    Route::get('pages/{page}/contents', [PageController::class, 'contents']);
    
    // Contents
    Route::get('contents', [ContentController::class, 'index']);
    Route::get('contents/{id}', [ContentController::class, 'show']);
    Route::get('contents/slug/{slug}', [ContentController::class, 'showBySlug']);
    Route::get('contents/type/{typeId}', [ContentController::class, 'byType']);
    Route::get('contents/page/{pageId}', [ContentController::class, 'byPage']);
    
    // Content Types
    Route::get('content-types', [ContentController::class, 'types']);
});
Route::get('/pages-with-contents', function () {
    try {
        $pages = Page::where('stats', 1)
            ->where('header', 0) // Filter PAGES where header = 0
            ->whereNotNull('page_name')
            ->where('page_name', '!=', 'الصفحة الرئيسية')
            ->orderBy('id')
            ->with(['contents' => function ($query) {
                $query->where('stats', 1)
                    ->whereNotNull('slug')
                    ->orderBy('id');
            }])
            ->get()
            ->map(function ($page) {
                return [
                    'id' => $page->id,
                    'name' => $page->page_name,
                    'name_en' => $page->page_name_en,
                    'slug' => strtolower(str_replace([' ', '/'], '-', $page->page_name)),
                    'header' => $page->header, // Include header value from page
                    'has_children' => $page->has_children,
                    'contents' => $page->contents->map(function ($content) {
                        return [
                            'id' => $content->id,
                            'slug' => $content->slug,
                            'slug_en' => $content->slug_en,
                            'page_id' => $content->page_id
                        ];
                    })
                ];
            });
            
        return response()->json([
            'success' => true,
            'data' => $pages,
            'count' => $pages->count(),
            'message' => 'Pages fetched successfully'
        ]);
    } catch (\Exception $e) {
        \Log::error('Failed to fetch pages: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch pages',
            'error' => $e->getMessage(),
            'trace' => env('APP_DEBUG') ? $e->getTrace() : []
        ], 500);
    }
});

// API endpoint for About Us page with all related data
Route::get('/about-us-content', function () {
    try {
        // First, find the "عن الهيئة" page
        $aboutPage = Page::where('page_name', 'عن الهيئة')
            ->where('stats', 1)
            ->where('header', 0)
            ->first();
            
        if (!$aboutPage) {
            return response()->json([
                'success' => false,
                'message' => 'About page not found',
                'data' => null
            ], 404);
        }
        
        // Get the "من نحن" content under the About page
        $aboutContent = Content::where('page_id', $aboutPage->id)
            ->where('slug', 'من نحن')
            ->where('stats', 1)
            ->first();
            
        if (!$aboutContent) {
            return response()->json([
                'success' => false,
                'message' => 'About content not found',
                'data' => null
            ], 404);
        }
        
        // Get all content_info records for this content
        $contentInfos = ContentInfo::where('content_id', $aboutContent->id)
            ->where('stats', 1)
            ->orderBy('id')
            ->get()
            ->map(function ($contentInfo) {
                // Get content_detail for this content_info if exists
                $contentDetail = ContentDetail::where('content_info_id', $contentInfo->id)
                    ->where('stats', operator: 1)
                    ->first();
                    
                return [
                    'id' => $contentInfo->id,
                    'content' => $contentInfo->content,
                    'content_en' => $contentInfo->content_en,
                    'content_type_id' => $contentInfo->content_type_id,
                    'detail' => $contentDetail ? [
                        'id' => $contentDetail->id,
                        'additional_info' => $contentDetail->additional_info,
                        'additional_info_en' => $contentDetail->additional_info_en,
                        'URL' => $contentDetail->URL,
                        'created_at' => $contentDetail->created_at,
                        'updated_at' => $contentDetail->updated_at
                    ] : null
                ];
            });
        
        // Organize data by sections
        $sections = [
            'من نحن' => null,
            'الرؤية' => null,
            'الرسالة' => null,
            'الأهداف' => null,
            'قيمنا' => null
        ];
        
        foreach ($contentInfos as $info) {
            $content = trim($info['content']);
            
            if (str_contains($content, 'من نحن')) {
                $sections['من نحن'] = $info['detail']['additional_info'] ?? '';
            } elseif (str_contains($content, 'الرؤية')) {
                $sections['الرؤية'] = $info['detail']['additional_info'] ?? '';
            } elseif (str_contains($content, 'الرسالة')) {
                $sections['الرسالة'] = $info['detail']['additional_info'] ?? '';
            } elseif (str_contains($content, 'الأهداف')) {
                $sections['الأهداف'] = $info['detail']['additional_info'] ?? '';
            } elseif (str_contains($content, 'قيمنا')) {
                $sections['قيمنا'] = $info['detail']['additional_info'] ?? '';
            }
        }
        
        // Parse objectives into list items
        $objectivesList = [];
        if ($sections['الأهداف']) {
            // Split by bullet points or new lines
            $lines = preg_split('/\r\n|\r|\n/', $sections['الأهداف']);
            $objectivesList = array_filter(array_map('trim', $lines));
        }
        
        // Parse values into array
        $valuesList = [];
        if ($sections['قيمنا']) {
            // Split values by line breaks
            $valueLines = preg_split('/\r\n|\r|\n/', $sections['قيمنا']);
            foreach ($valueLines as $line) {
                $line = trim($line);
                if (!empty($line)) {
                    // Check if line contains colon separator
                    if (str_contains($line, ':')) {
                        $parts = explode(':', $line, 2);
                        $valuesList[] = [
                            'name' => trim($parts[0]),
                            'description' => trim($parts[1])
                        ];
                    } else {
                        $valuesList[] = [
                            'name' => $line,
                            'description' => ''
                        ];
                    }
                }
            }
        }
        
        return response()->json([
            'success' => true,
            'data' => [
                'page_title' => 'من نحن',
                'page_description' => 'تعرف على الهيئة العامة لتنمية المشاريع الصغيرة والأصغر، رؤيتها ورسالتها وأهدافها وقيمها التي تخدم رواد الأعمال وأصحاب المشاريع الصغيرة.',
                'sections' => [
                    'about_us' => $sections['من نحن'],
                    'vision' => $sections['الرؤية'],
                    'mission' => $sections['الرسالة'],
                    'objectives' => $objectivesList,
                    'values' => $valuesList
                ]
            ],
            'message' => 'About us content fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch about us content: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch about us content',
            'error' => $e->getMessage()
        ], 500);
    }
});

// FAQ API endpoint
Route::get('/faq-content', function () {
    try {
        // First, find the "عن الهيئة" page
        $aboutPage = \App\Models\Page::where('page_name', 'عن الهيئة')
            ->where('stats', 1)
            ->first();
            
        if (!$aboutPage) {
            return response()->json([
                'success' => false,
                'message' => 'About page not found',
                'data' => null
            ], 404);
        }
        
        // Find the "الأسئلة الشائعة" content under the About page
        $faqContent = \App\Models\Content::where('page_id', $aboutPage->id)
            ->where('slug', 'الأسئلة الشائعة')
            ->where('stats', 1)
            ->first();
            
        if (!$faqContent) {
            return response()->json([
                'success' => false,
                'message' => 'FAQ content not found',
                'data' => null
            ], 404);
        }
        
        // Get all content_info records for FAQ (questions)
        $faqQuestions = \App\Models\ContentInfo::where('content_id', $faqContent->id)
            ->where('stats', 1)
            ->orderBy('id')
            ->get();
        
        // Collect all FAQ items with their answers
        $faqItems = [];
        
        foreach ($faqQuestions as $question) {
            // Get the answer from content_details
            $answer = \App\Models\ContentDetail::where('content_info_id', $question->id)
                ->where('stats', 1)
                ->first();
            
            if (!empty(trim($question->content))) {
                $faqItems[] = [
                    'id' => $question->id,
                    'question' => trim($question->content),
                    'answer' => $answer ? trim($answer->additional_info) : 'لا توجد إجابة متاحة حالياً.',
                    'content_type_id' => $question->content_type_id,
                    'created_at' => $question->created_at,
                    'updated_at' => $question->updated_at
                ];
            }
        }
        
        // Sort by ID to maintain order
        usort($faqItems, function ($a, $b) {
            return $a['id'] - $b['id'];
        });
        
        return response()->json([
            'success' => true,
            'data' => [
                'page_title' => 'الأسئلة الشائعة',
                'page_description' => 'هنا تجد إجابات لأكثر الأسئلة شيوعًا حول خدمات وبرامج الهيئة العامة لتنمية المشاريع الصغيرة والأصغر.',
                'faq_items' => $faqItems
            ],
            'count' => count($faqItems),
            'message' => 'FAQ content fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch FAQ content: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch FAQ content',
            'error' => $e->getMessage(),
            'trace' => env('APP_DEBUG') ? $e->getTraceAsString() : []
        ], 500);
    }
});


// Alternative: Direct FAQ endpoint using your database structure
Route::get('/faq-items', function () {
    try {
        // Get FAQ content by page name and content slug
        $faqPage = Page::where('page_name', 'الاسئلة الشائعة')
            ->where('stats', 1)
            ->first();
        
        if (!$faqPage) {
            // Fallback: Try to get any FAQ content
            $faqContent = Content::where('slug', 'like', '%سؤال%')
                ->orWhere('slug', 'like', '%أسئلة%')
                ->where('stats', 1)
                ->first();
                
            if (!$faqContent) {
                return response()->json([
                    'success' => false,
                    'message' => 'No FAQ content found',
                    'data' => []
                ], 404);
            }
            
            $pageId = $faqContent->page_id;
        } else {
            $pageId = $faqPage->id;
        }
        
        // Get all FAQ contents for this page
        $faqContents = Content::where('page_id', $pageId)
            ->where('stats', 1)
            ->get();
        
        $allFaqItems = [];
        
        foreach ($faqContents as $content) {
            $contentInfos = ContentInfo::where('content_id', $content->id)
                ->where('stats', 1)
                ->with('contentDetail')
                ->get();
            
            foreach ($contentInfos as $info) {
                if (!empty(trim($info->content))) {
                    $allFaqItems[] = [
                        'id' => $info->id,
                        'question' => trim($info->content),
                        'answer' => $info->contentDetail ? 
                            (trim($info->contentDetail->additional_info) ?: 'لا توجد إجابة متاحة حالياً.') : 
                            'لا توجد إجابة متاحة حالياً.',
                        'content_id' => $info->content_id,
                        'content_type_id' => $info->content_type_id
                    ];
                }
            }
        }
        
        // Remove duplicates based on question
        $uniqueFaqItems = [];
        $seenQuestions = [];
        
        foreach ($allFaqItems as $item) {
            $questionKey = md5($item['question']);
            if (!in_array($questionKey, $seenQuestions)) {
                $seenQuestions[] = $questionKey;
                $uniqueFaqItems[] = $item;
            }
        }
        
        // Sort by ID to maintain order
        usort($uniqueFaqItems, function ($a, $b) {
            return $a['id'] - $b['id'];
        });
        
        return response()->json([
            'success' => true,
            'data' => [
                'page_title' => 'الأسئلة الشائعة',
                'page_description' => 'هنا تجد إجابات لأكثر الأسئلة شيوعًا حول خدمات وبرامج الهيئة العامة لتنمية المشاريع الصغيرة والأصغر.',
                'faq_items' => $uniqueFaqItems
            ],
            'count' => count($uniqueFaqItems),
            'message' => 'FAQ items fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch FAQ items',
            'error' => $e->getMessage()
        ], 500);
    }
});
// Correct API endpoint for Funding Partners
Route::get('/funding-partners', function () {
    try {
        // First, find the "شركاء ممولين" in Content_info table
        $fundingPartnerHeader = ContentInfo::where('content', 'شركاء ممولين')
            ->where('stats', 1)
            ->first();
        
        if (!$fundingPartnerHeader) {
            // Try with different variations
            $fundingPartnerHeader = ContentInfo::where('content', 'like', '%شركاء ممولين%')
                ->where('stats', 1)
                ->first();
        }
        
        if (!$fundingPartnerHeader) {
            // Try to find any content that contains "ممول" in Content_info
            $fundingPartnerHeader = ContentInfo::where('content', 'like', '%ممول%')
                ->where('stats', 1)
                ->first();
        }
        
        if (!$fundingPartnerHeader) {
            return response()->json([
                'success' => false,
                'message' => 'Funding partners section not found in Content_info',
                'data' => []
            ], 404);
        }
        
        // Get the ContentDetail for the header (this has the logo URL)
        $headerDetail = ContentDetail::where('content_info_id', $fundingPartnerHeader->id)
            ->where('stats', 1)
            ->first();
        
        $partners = [];
        
        // Now, find ALL Content_info entries that are actual partners (not the header)
        // They should have the same content_id as the header
        $allPartnerInfos = ContentInfo::where('content_id', $fundingPartnerHeader->content_id)
            ->where('id', '!=', $fundingPartnerHeader->id) // Exclude the header itself
            ->where('stats', 1)
            ->get();
        
        foreach ($allPartnerInfos as $partnerInfo) {
            // Get the details for each partner
            $partnerDetail = ContentDetail::where('content_info_id', $partnerInfo->id)
                ->where('stats', 1)
                ->first();
            
            // Clean up the partner name
            $partnerName = trim($partnerInfo->content);
            if (empty($partnerName)) {
                continue; // Skip empty names
            }
            
            $partners[] = [
                'id' => $partnerInfo->id,
                'name' => $partnerName,
                'description' => $partnerDetail ? trim($partnerDetail->additional_info ?? '') : '',
                'logo_url' => $partnerDetail ? trim($partnerDetail->URL ?? '') : 
                             ($headerDetail ? trim($headerDetail->URL ?? '') : ''), // Fallback to header logo
                'website' => $partnerDetail ? trim($partnerDetail->URL ?? '') : ''
            ];
        }
        
        // If no partners found, check if there are partners in other content_ids
        if (empty($partners)) {
            // Look for any Content_info that might be a partner (contains partner names)
            $potentialPartners = ContentInfo::where('content', 'not like', '%شركاء%')
                ->where('content', 'not like', '%ممول%') // Exclude headers
                ->where('content', 'not like', '%منفذ%')
                ->where('stats', 1)
                ->get();
            
            foreach ($potentialPartners as $partnerInfo) {
                $partnerDetail = ContentDetail::where('content_info_id', $partnerInfo->id)
                    ->where('stats', 1)
                    ->first();
                
                $partnerName = trim($partnerInfo->content);
                if (!empty($partnerName)) {
                    $partners[] = [
                        'id' => $partnerInfo->id,
                        'name' => $partnerDetail ? trim($partnerDetail->additional_info ?? '') : '',
                        'description' => $partnerDetail ? trim($partnerDetail->additional_info ?? '') : '',
                        'logo_url' => $partnerDetail ? trim($partnerDetail->URL ?? '') : '',
                        'website' => $partnerDetail ? trim($partnerDetail->URL ?? '') : ''
                    ];
                }
            }
        }
        
        return response()->json([
            'success' => true,
            'data' => [
                'page_title' => 'الشركاء الممولون',
                'page_description' => 'شركاؤنا الذين يدعموننا ماليًا لتحقيق أهدافنا التنموية في خدمة المشاريع الصغيرة والأصغر.',
                'partners' => $partners
            ],
            'count' => count($partners),
            'debug' => [
                'header_found' => $fundingPartnerHeader ? true : false,
                'header_id' => $fundingPartnerHeader ? $fundingPartnerHeader->id : null,
                'header_content' => $fundingPartnerHeader ? $fundingPartnerHeader->content : null,
                'header_content_id' => $fundingPartnerHeader ? $fundingPartnerHeader->content_id : null,
                'total_partners_found' => count($partners)
            ],
            'message' => 'Funding partners fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch funding partners: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch funding partners',
            'error' => $e->getMessage(),
            'trace' => env('APP_DEBUG') ? $e->getTraceAsString() : []
        ], 500);
    }
});
// API endpoint for Partners page (main partners listing)
Route::get('/partners-content', function () {
    try {
        // Find the "الشركاء" content in Contents table
        $partnersContent = Content::where('slug', 'الشركاء')
            ->where('stats', 1)
            ->first();
        // echo("parntersContent:".$partnersContent);
        if (!$partnersContent) {
            return response()->json([
                'success' => false,
                'message' => 'Partners page not found',
                'data' => null
            ], 404);
        }
        // Get all content_info records for partners (الشركاء المنفذون and الشركاء الممولون)
        $partnersInfo = ContentInfo::where('content_id', $partnersContent->id)
            ->where('stats', 1)
            ->orderBy('id')
            ->get();
                        // echo("partnersInfo:".$partnersInfo);

        // $partnersList = [];
        
        // foreach ($partnersInfo as $info) {
        //     $content = trim($info->content);
        //     $detail = ContentDetail::where('content_info_id', $info->id)
        //         ->where('stats', 1)
        //         ->first();
            
        //     // Determine partner type and create appropriate response
        //     if (str_contains($content, 'الشركاء الممولون')) {
        //         $partnersList[] = [
        //             'title' => 'الشركاء الممولون',
        //             'link' => '/partners/funders',
        //             'desc' => trim($detail->additional_info)
        //         ];
        //     } elseif (str_contains($content, 'الشركاء المنفذون')) {
        //         $partnersList[] = [
        //             'title' => 'الشركاء المنفذون',
        //             'link' => '/partners/executors',
        //             'desc' => trim($detail->additional_info)
        //         ];
        //     }
        // }
        
        // // If no specific content found, create default entries
        // if (empty($partnersList)) {
        //     $partnersList = [
        //         [
        //             'title' => 'الشركاء المنفذون',
        //             'link' => '/partners/executors',
        //             'desc' => 'شركاؤنا المنفذون هم الذراع التنفيذية التي حولت الرؤى إلى واقع ملموس من خلال شراكات استراتيجية مبنية على الثقة والكفاءة.'
        //         ],
        //         [
        //             'title' => 'الشركاء الممولون',
        //             'link' => '/partners/funders',
        //             'desc' => 'نعتز بشركائنا الممولين الذين أسهموا في دعم وتمويل البرامج والمشاريع التنموية التي تخدم المجتمع وتدعم الاقتصاد المحلي.'
        //         ]
        //     ];
        // }
        
        return response()->json([
            'success' => true,
            'data' => $partnersInfo,
            'message' => 'Partners content fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch partners content: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch partners content',
            'error' => $e->getMessage()
        ], 500);
    }
});

// Correct API endpoint for Implementation Partners
Route::get('/implementation-partners', function () {
    try {
        // First, find the "شركاء منفذون" in Content_info table
        $implementationPartnerHeader = ContentInfo::where('content', 'like', '%الشركاء المنفذون%')
            ->where('stats', 1)
            ->first();
        
        if (!$implementationPartnerHeader) {
            return response()->json([
                'success' => false,
                'message' => 'Implementation partners section not found in Content_info',
                'data' => []
            ], 404);
        }
        
        // Get the ContentDetail for the header
        $headerDetail = ContentDetail::where('content_info_id', $implementationPartnerHeader->id)
            ->where('stats', 1)
            ->first();
        
        $partners = [];
        
        // Now we need a different approach since implementation partners might be in a different structure
        // Let's look for implementation partners specifically
        
        // Method 1: Look for partners that are specifically implementation partners
        // Based on your database, implementation partners might be marked differently
        
        // First, let's get all content_info to see what we have
        $allContentInfo = ContentInfo::where('content_id', 3)
            ->where('stats', 1)
            ->orderBy('id')
            ->get();
        
        // Debug: Log all content to understand the structure
        $debugContent = [];
        foreach ($allContentInfo as $info) {
            $debugContent[] = [
                'id' => $info->id,
                'content' => $info->content,
                'content_id' => $info->content_id
            ];
        }
        
        // Since we can't reliably identify implementation partners by content,
        // let's check if there's a specific pattern or if we need to manually specify
        
        // For now, let's return an empty array since we can't identify implementation partners
        // You'll need to add implementation partners data to your database
        
        return response()->json([
            'success' => true,
            'data' => [
                'page_title' => 'الشركاء المنفذون',
                'page_description' => 'شركاؤنا الذين يعملون معنا على أرض الواقع لتنفيذ المشاريع والبرامج التنموية.',
                'partners' => [] // Empty for now
            ],
            'debug' => [
                'header_found' => $implementationPartnerHeader ? true : false,
                'header_content' => $implementationPartnerHeader ? $implementationPartnerHeader->content : null,
                'all_content_count' => count($allContentInfo),
                'all_content_samples' => array_slice($debugContent, 0, 5) // First 5 items
            ],
            'message' => 'No implementation partners found in database. Please add implementation partners data.'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch implementation partners: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch implementation partners',
            'error' => $e->getMessage()
        ], 500);
    }
});

// Alternative: Manual implementation partners endpoint
Route::get('/implementation-partners-manual', function () {
    try {
        // Since implementation partners might not be in the database yet,
        // let's check if there are any partners that could be implementation partners
        
        $possibleImplementationPartners = ContentInfo::where('content_id', 3)
            ->where('stats', 1)
            ->where(function($query) {
                // Look for content that might be implementation partners
                $query->where('content', 'like', '%منفذ%')
                      ->orWhere('content', 'like', '%تنفيذ%')
                      ->orWhere('content', 'like', '%تنفيذي%')
                      ->orWhere('content', 'like', '%تنفيذية%');
            })
            ->where('content', 'not like', '%شركاء منفذون%') // Exclude the header
            ->get();
        
        $partners = [];
        
        foreach ($possibleImplementationPartners as $partnerInfo) {
            $partnerDetail = ContentDetail::where('content_info_id', $partnerInfo->id)
                ->where('stats', 1)
                ->first();
            
            $partnerName = trim($partnerInfo->content);
            if (!empty($partnerName)) {
                $partners[] = [
                    'id' => $partnerInfo->id,
                    'name' => $partnerName,
                    'description' => $partnerDetail ? trim($partnerDetail->additional_info ?? '') : '',
                    'logo_url' => $partnerDetail ? trim($partnerDetail->URL ?? '') : '',
                    'website' => $partnerDetail ? trim($partnerDetail->URL ?? '') : ''
                ];
            }
        }
        
        // If no partners found, check if there's specific implementation partners content
        if (empty($partners)) {
            // Check for Content_info that might contain implementation partners list
            $implementationContent = ContentInfo::where('content', 'like', '%منفذ%')
                ->where('content', 'not like', '%شركاء منفذون%')
                ->where('stats', 1)
                ->first();
            
            if ($implementationContent) {
                $detail = ContentDetail::where('content_info_id', $implementationContent->id)
                    ->where('stats', 1)
                    ->first();
                
                // If there's additional_info with implementation partners list
                if ($detail && !empty($detail->additional_info)) {
                    // Parse the additional_info for partners
                    $lines = explode("\n", $detail->additional_info);
                    $partnerIndex = 1;
                    
                    foreach ($lines as $line) {
                        $line = trim($line);
                        if (!empty($line)) {
                            $partners[] = [
                                'id' => $partnerIndex++,
                                'name' => $line,
                                'description' => '',
                                'logo_url' => $detail->URL ?? '',
                                'website' => $detail->URL ?? ''
                            ];
                        }
                    }
                }
            }
        }
        
        return response()->json([
            'success' => true,
            'data' => [
                'page_title' => 'الشركاء المنفذون',
                'page_description' => 'شركاؤنا الذين يعملون معنا على أرض الواقع لتنفيذ المشاريع والبرامج التنموية.',
                'partners' => $partners
            ],
            'count' => count($partners),
            'message' => 'Implementation partners fetched'
        ]);
        
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch implementation partners',
            'error' => $e->getMessage()
        ], 500);
    }
});
// API endpoint for Studies page
Route::get('/studies-content', function () {
    try {
        // Find the "الدراسات" content in Contents table
        $studiesContent = \App\Models\Content::where('slug', 'الدراسات')
            ->where('stats', 1)
            ->first();
            
        if (!$studiesContent) {
            return response()->json([
                'success' => false,
                'message' => 'Studies page not found',
                'data' => null
            ], 404);
        }
        
        // Get all content_info records for studies
        $studiesInfo = \App\Models\ContentInfo::where('content_id', $studiesContent->id)
            ->where('stats', 1)
            ->orderBy('id')
            ->get();
        
        $studiesList = [];
        
        foreach ($studiesInfo as $study) {
            $detail = \App\Models\ContentDetail::where('content_info_id', $study->id)
                ->where('stats', 1)
                ->first();
            
            // Extract file URL if available (from URL field or additional_info)
            $fileUrl = null;
            $description = null;
            
            if ($detail) {
                // Check URL field first
                if (!empty($detail->URL)) {
                    $fileUrl = trim($detail->URL);
                }
                
                // Check additional_info for description or additional file URLs
                if (!empty($detail->additional_info)) {
                    $description = trim($detail->additional_info);
                }
            }
            
            $studiesList[] = [
                'id' => $study->id,
                'title' => trim(string: $study->content),
                'description' => $description ?: 'دراسة تبحث في تطوير المشاريع الصغيرة والتنمية الاقتصادية',
                'file_url' => $fileUrl,
                'image_url' => $fileUrl && (str_ends_with($fileUrl, '.jpg') || str_ends_with($fileUrl, '.jpeg') || str_ends_with($fileUrl, '.png')) 
                    ? $fileUrl 
                    : null,
                'content_type_id' => $study->content_type_id,
                'created_at' => $study->created_at,
                'updated_at' => $study->updated_at
            ];
        }
        
        // If no studies found in database, return default data
        if (empty($studiesList)) {
            $studiesList = [
                [
                    'id' => 1,
                    'title' => 'تحليل سلسلة قيمة إنتاج الملابس المحلية',
                    'description' => 'دراسة "سلسلة القيمة للملابس المحلية" تسلط الضوء على رحلة المنتجين الصغار في أمانة العاصمة، من التحديات إلى الفرص، وتطرح رؤية عملية لتطوير الجودة، وتوسيع الأسواق، وتعزيز حضور الملابس المحلية كمنافس قوي في السوق.',
                    'file_url' => '/documents/study-1.pdf',
                    'image_url' => null,
                    'created_at' => now(),
                    'updated_at' => now()
                ]
            ];
        }
        
        return response()->json([
            'success' => true,
            'data' => [
                'page_title' => 'الدراسات',
                'page_description' => 'تصفح دراساتنا الحديثة التي تسلط الضوء على المشاريع المحلية والتنمية الاقتصادية في اليمن، واكتشف كيف تسهم هذه الدراسات في تعزيز المعرفة والوعي ودعم اتخاذ القرار في مختلف المجالات.',
                'studies' => $studiesList
            ],
            'message' => 'Studies content fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch studies content: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch studies content',
            'error' => $e->getMessage()
        ], 500);
    }
});
// API endpoint for Contact Us page
Route::get('/contact-content', function () {
    try {
        // Find the "تواصل معنا" content in Contents table
        $contactContent = \App\Models\Content::where('slug', 'تواصل معنا')
            ->where('stats', 1)
            ->first();
            
        if (!$contactContent) {
            return response()->json([
                'success' => false,
                'message' => 'Contact page not found',
                'data' => null
            ], 404);
        }
        
        // Get all content_info records for contact us
        $contactInfo = \App\Models\ContentInfo::where('content_id', $contactContent->id)
            ->where('stats', 1)
            ->orderBy('id')
            ->get();
        
        $contactData = [
            'page_title' => 'تواصل معنا',
            'page_description' => 'نحن هنا لدعمك والإجابة على استفساراتك حول المشاريع الصغيرة والأصغر. يسعدنا التواصل معك في حال كان لديك سؤال أو اقتراح.',
            'sections' => []
        ];
        
        foreach ($contactInfo as $info) {
            $detail = \App\Models\ContentDetail::where('content_info_id', $info->id)
                ->where('stats', 1)
                ->first();
            
            $title = trim($info->content);
            $description = $detail ? trim($detail->additional_info) : '';
            $url = $detail ? trim($detail->URL) : '';
            
            // Debug: Log what we're finding
            // \Log::info("Contact Section: $title, ID: $info->id");
            
            // Match exact titles from database
            if ($title === 'اتصل بنا') {
                $contactData['sections']['contact_phone'] = [
                    'id' => $info->id,
                    'title' => $title,
                    'description' => $description,
                    'url' => $url,
                    'type' => 'phone'
                ];
            } elseif ($title === 'نموذج تواصل') {
                $contactData['sections']['contact_form'] = [
                    'id' => $info->id,
                    'title' => $title,
                    'description' => $description,
                    'url' => $url,
                    'type' => 'form'
                ];
            } elseif ($title === 'العنوان') {
                $contactData['sections']['address'] = [
                    'id' => $info->id,
                    'title' => $title,
                    'description' => $description,
                    'url' => $url,
                    'type' => 'address'
                ];
            } elseif ($title === 'وسائل التواصل الاجتماعي') {
                // Parse social media URLs from description
                $socialLinks = [];
                
                // Check both description and URL fields for social links
                $socialText = $description ?: $url;
                
                if ($socialText) {
                    // Split by spaces, newlines, or multiple spaces
                    $urls = preg_split('/\s+/', $socialText);
                    
                    foreach ($urls as $socialUrl) {
                        $socialUrl = trim($socialUrl);
                        
                        if (!empty($socialUrl) && filter_var($socialUrl, FILTER_VALIDATE_URL)) {
                            // Determine platform from URL
                            $lowerUrl = strtolower($socialUrl);
                            
                            if (str_contains($lowerUrl, 'facebook.com')) {
                                $socialLinks[] = [
                                    'platform' => 'facebook',
                                    'url' => $socialUrl,
                                    'icon' => 'facebook.png'
                                ];
                            } elseif (str_contains($lowerUrl, 'youtube.com')) {
                                $socialLinks[] = [
                                    'platform' => 'youtube',
                                    'url' => $socialUrl,
                                    'icon' => 'youtube.png'
                                ];
                            } elseif (str_contains($lowerUrl, 't.me')) {
                                $socialLinks[] = [
                                    'platform' => 'telegram',
                                    'url' => $socialUrl,
                                    'icon' => 'telegram.png'
                                ];
                            } elseif (str_contains($lowerUrl, 'whatsapp.com') || str_contains($lowerUrl, 'wa.me')) {
                                $socialLinks[] = [
                                    'platform' => 'whatsapp',
                                    'url' => $socialUrl,
                                    'icon' => 'whatsapp.png'
                                ];
                            } elseif (str_contains($lowerUrl, 'x.com') || str_contains($lowerUrl, 'twitter.com')) {
                                $socialLinks[] = [
                                    'platform' => 'x',
                                    'url' => $socialUrl,
                                    'icon' => 'x.svg'
                                ];
                            }
                        }
                    }
                }
                
                $contactData['sections']['social_media'] = [
                    'id' => $info->id,
                    'title' => $title,
                    'description' => 'حساباتنا الرسمية على مواقع التواصل', // Static description
                    'social_links' => $socialLinks,
                    'type' => 'social'
                ];
            } elseif ($title === 'البريد الإلكتروني') {
                $contactData['sections']['email'] = [
                    'id' => $info->id,
                    'title' => $title,
                    'description' => $description ?: $url,
                    'url' => $url,
                    'type' => 'email'
                ];
            }
        }
        
        // Check for missing sections and add default data
        if (!isset($contactData['sections']['contact_form'])) {
            $contactData['sections']['contact_form'] = [
                'title' => 'نموذج تواصل',
                'description' => "السبت – الأربعاء\n8:00 صباحًا – 1:00 مساءً",
                'type' => 'form'
            ];
        }
        
        // Ensure all sections have IDs for consistency
        foreach ($contactData['sections'] as $key => $section) {
            if (!isset($section['id'])) {
                $contactData['sections'][$key]['id'] = 0;
            }
        }
        
        return response()->json([
            'success' => true,
            'data' => $contactData,
            'message' => 'Contact content fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch contact content: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch contact content',
            'error' => $e->getMessage()
        ], 500);
    }
});
// API endpoint for Services page
Route::get('/services-content', function () {
    try {
        // Find the "الخدمات" content in Contents table
        $servicesContent = \App\Models\Content::where('slug', 'like', '%خدمات%')
            ->where('stats', 1)
            ->first();
            
        if (!$servicesContent) {
            return response()->json([
                'success' => false,
                'message' => 'Services page not found',
                'data' => null
            ], 404);
        }
        
        // Get all content_info records for services (check based on your data structure)
        $servicesInfo = \App\Models\ContentInfo::where('content_id', $servicesContent->id)
            ->where('stats', 1)
            ->orderBy('id')
            ->get();
        
        $servicesList = [];
        
        // Since you have services in Contents table with slugs like "خدمات التدريب", "خدمات التمويل", etc.
        // Let's get all service-related content
        $allServices = \App\Models\Content::where('page_id', $servicesContent->page_id)
            ->where('stats', 1)
            ->where(function($query) {
                $query->where('slug', 'like', '%خدمات%')
                      ->orWhere('content_title', 'like', '%خدمة%');
            })
            ->get();
        
        foreach ($allServices as $service) {
            // Get the main content info for this service
            $serviceInfo = \App\Models\ContentInfo::where('content_id', $service->id)
                ->where('stats', 1)
                ->first();
            
            if ($serviceInfo) {
                // Get details if available
                $serviceDetail = \App\Models\ContentDetail::where('content_info_id', $serviceInfo->id)
                    ->where('stats', 1)
                    ->first();
                
                $serviceName = trim($service->slug) ?: trim($service->slug) ?: trim($service->slug);
                $serviceDescription = $serviceDetail ? trim($serviceInfo->additional_info) : '';
                $serviceImage = $serviceDetail ? trim($serviceDetail->URL) : null;
                
                // Map service type to appropriate link and image
                $serviceType = strtolower($serviceName);
                $link = '/services/';
                $defaultImage = '/assets/images/logo.png';
                
                if (str_contains($serviceType, 'تدريب') || str_contains($serviceType, 'training')) {
                    $link .= 'training';
                    $defaultImage = '/assets/services/training.jpg';
                } elseif (str_contains($serviceType, 'تمويل') || str_contains($serviceType, 'funding')) {
                    $link .= 'funding';
                    $defaultImage = '/assets/services/funding.jpg';
                } elseif (str_contains($serviceType, 'استشارات') || str_contains($serviceType, 'consulting')) {
                    $link .= 'consulting';
                    $defaultImage = '/assets/services/consulting.jpg';
                } elseif (str_contains($serviceType, 'تسويق') || str_contains($serviceType, 'marketing')) {
                    $link .= 'marketing';
                    $defaultImage = '/assets/services/marketing.jpg';
                } else {
                    // Generic service link
                    $link .= str_replace(' ', '-', $serviceType);
                }
                
                $servicesList[] = [
                    'id' => $service->id,
                    'title' => $serviceName,
                    'desc' => $serviceDescription ?: $service->content_description ?: 'خدمة مقدمة من الهيئة العامة لتنمية المشاريع الصغيرة والأصغر',
                    'image' => $serviceImage ?: $defaultImage,
                    'link' => $link,
                    'slug' => $service->slug,
                    'content_type_id' => $serviceInfo->content_type_id
                ];
            }
        }
        
        // If no services found, use default data
        if (empty($servicesList)) {
            $servicesList = [
                [
                    'id' => 1,
                    'title' => 'خدمة التدريب',
                    'desc' => 'تقدم الهيئة برامج تدريبية متخصصة تهدف إلى تطوير مهارات رواد الأعمال والمشاريع الصغيرة في مجالات التصنيع الغذائي، الجلود الطبيعية، الخياطة، الحرف اليدوية، وريادة الأعمال.',
                    'image' => '/assets/services/training.jpg',
                    'link' => '/services/training'
                ],
                [
                    'id' => 2,
                    'title' => 'خدمة التسويق',
                    'desc' => 'نسعى لتسويق منتجات المشاريع الصغيرة عبر المعارض والفعاليات والمنصات الرقمية، لتمكينها من الوصول إلى أسواق أوسع وزيادة فرص نجاحها.',
                    'image' => '/assets/services/marketing.jpg',
                    'link' => '/services/marketing'
                ],
                [
                    'id' => 3,
                    'title' => 'خدمة التمويل',
                    'desc' => 'تقدم الهيئة قروضاً بيضاء عبر الجمعيات الشريكة لدعم المشاريع في مجالات الثروة الحيوانية، الصيد البحري، التصنيع الغذائي، الخياطة، والحرف اليدوية.',
                    'image' => '/assets/services/funding.jpg',
                    'link' => '/services/funding'
                ],
                [
                    'id' => 4,
                    'title' => 'خدمة الاستشارات',
                    'desc' => 'نقدم استشارات متخصصة تساعد أصحاب المشاريع على النمو والتطور، مع التركيز على التخطيط، الإدارة، الإنتاج، والتسويق.',
                    'image' => '/assets/services/consulting.jpg',
                    'link' => '/services/consulting'
                ]
            ];
        }
        
        return response()->json([
            'success' => true,
            'data' => [
                'page_title' => 'خدمات الهيئة',
                'page_description' => 'في الهيئة العامة لتنمية المشاريع الصغيرة والأصغر، نعمل على تقديم مجموعة متكاملة من الخدمات التي تهدف إلى دعم أصحاب المشاريع في جميع المراحل.',
                'services' => $servicesList
            ],
            'message' => 'Services content fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch services content: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch services content',
            'error' => $e->getMessage()
        ], 500);
    }
});
// API endpoint for Government Facilities page
Route::get('/government-facilities-content', function () {
    try {
        // Find the "التسهيلات الحكومية" page in Pages table
        $govPage = \App\Models\Page::where('page_name', 'التسهيلات الحكومية')
            ->where('stats', 1)
            ->first();
            
        if (!$govPage) {
            return response()->json([
                'success' => false,
                'message' => 'Government facilities page not found',
                'data' => null
            ], 404);
        }
        
        // Find ALL content related to this page in Contents table
        $govContents = \App\Models\Content::where('page_id', $govPage->id)
            ->where('stats', 1)
            ->get();
        
        $facilitiesData = [
            'page_title' => 'التسهيلات الحكومية',
            'page_description' => 'نوفر لك دليلاً شاملاً للتسهيلات والخدمات الحكومية التي تساعد رواد الأعمال وأصحاب المشاريع الصغيرة والأصغر على الانطلاق والنمو بسهولة، مع شرح مبسط للإجراءات والمتطلبات.',
            'facilities' => []
        ];
        
        foreach ($govContents as $content) {
            // Get content_info records for this content
            $facilitiesInfo = \App\Models\ContentInfo::where('content_id', $content->id)
                ->where('stats', 1)
                ->get();
            
            if ($facilitiesInfo->isEmpty()) {
                // If no content_info found, create facility from the Content itself
                $detail = \App\Models\ContentDetail::where('content_info_id', $content->id)
                    ->where('stats', 1)
                    ->first();
                
                $facilitiesData['facilities'][] = [
                    'id' => $content->id,
                    'title' => trim($content->slug) ?: 'مذكرة المواصفات والمقاييس',
                    'description' => $detail ? trim($content->content_description) : 'تسهيلات حكومية مقدمة من الهيئة العامة لتنمية المشاريع الصغيرة والأصغر',
                    'page_slug' => trim($content->slug),
                    'form_slug' => 'specs-memo-request',
                    'type' => 'government_facility',
                    'created_at' => $content->created_at,
                    'updated_at' => $content->updated_at
                ];
            } else {
                // If content_info exists, use it
                foreach ($facilitiesInfo as $info) {
                    $detail = \App\Models\ContentDetail::where('content_info_id', $info->id)
                        ->where('stats', 1)
                        ->first();
                    
                    $facilitiesData['facilities'][] = [
                        'id' => $info->id,
                        'title' => trim($info->content) ?: trim($content->slug),
                        'description' => $detail ? trim($detail->additional_info) : ($content->content_description ?: ''),
                        'page_slug' => trim($content->slug),
                        'form_slug' => 'specs-memo-request',
                        'type' => 'government_facility',
                        'created_at' => $info->created_at,
                        'updated_at' => $info->updated_at
                    ];
                }
            }
        }
        
        // If still no facilities found, use data from Contents table directly
        if (empty($facilitiesData['facilities'])) {
            // Try to get any content with government-related slugs
            $govRelatedContent = \App\Models\Content::where(function($query) {
                $query->where('slug', 'like', '%تسهيلات%')
                      ->orWhere('slug', 'like', '%حكومي%')
                      ->orWhere('content_title', 'like', '%تسهيلات%');
            })
            ->where('stats', 1)
            ->get();
            
            foreach ($govRelatedContent as $content) {
                $facilitiesData['facilities'][] = [
                    'id' => $content->id,
                    'title' => trim($content->slug) ?: 'تسهيلات حكومية',
                    'description' => $content->content_description ?: 'تسهيلات حكومية مقدمة من الهيئة العامة لتنمية المشاريع الصغيرة والأصغر',
                    'page_slug' => trim($content->slug),
                    'form_slug' => trim($content->slug),
                    'type' => 'government_facility',
                    'created_at' => $content->created_at,
                    'updated_at' => $content->updated_at
                ];
            }
        }
        
        // If absolutely no facilities found, use default data
        if (empty($facilitiesData['facilities'])) {
            $facilitiesData['facilities'] = [
                [
                    'id' => 1,
                    'title' => 'مذكرة المواصفات والمقاييس',
                    'description' => 'تصدر الهيئة العامة لتنمية المشاريع الصغيرة والأصغر مذكرات رسمية موجهة إلى الجهات الحكومية ذات العلاقة، ومنها الهيئة اليمنية للمواصفات والمقاييس وضبط الجودة، وذلك لتسهيل إجراءات تسجيل وترخيص المشاريع الصغيرة والأصغر، وتمكينها من الحصول على الدعم اللوجستي والخدمات وفق الأنظمة المعتمدة. تمثل هذه المذكرات أداة هامة لدعم رواد الأعمال وتعزيز استدامة المشاريع الإنتاجية الصغيرة.',
                    'page_slug' => 'مذكرة المواصفات والمقاييس',
                    'form_slug' => 'specs-memo-request',
                    'type' => 'government_facility'
                ]
            ];
        }
        
        return response()->json([
            'success' => true,
            'data' => $facilitiesData,
            'message' => 'Government facilities content fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch government facilities content: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch government facilities content',
            'error' => $e->getMessage()
        ], 500);
    }
});

// Helper function to get form slug from title
function getFormSlugFromTitle($title)
{
    $title = strtolower(trim($title));
    
    if (str_contains($title, 'مواصفات') || str_contains($title, 'مقاييس')) {
        return 'specs-memo-request';
    } elseif (str_contains($title, 'ترخيص') || str_contains($title, 'رخصة')) {
        return 'licensing-request';
    } elseif (str_contains($title, 'دعم') || str_contains($title, 'تمويل')) {
        return 'support-request';
    } elseif (str_contains($title, 'استشارة') || str_contains($title, 'استشارات')) {
        return 'consultation-request';
    }
    
    return 'general-request';
}
// API endpoint for Awareness Flashes page
Route::get('/awareness-flashes-content', function () {
    try {
        // Find the "قسم الإعلام والتوعية" page in Pages table
        $mediaPage = \App\Models\Page::where('page_name', 'قسم الإعلام والتوعية')
            ->where('stats', 1)
            ->first();
            
        if (!$mediaPage) {
            return response()->json([
                'success' => false,
                'message' => 'Media page not found',
                'data' => null
            ], 404);
        }
        
        // Find the "فلاشات توعوية" content in Contents table
        $flashesContent = \App\Models\Content::where('page_id', $mediaPage->id)
            ->where('slug', 'فلاشات توعوية')
            ->where('stats', 1)
            ->first();
        
        $flashesData = [
            'page_title' => 'الفلاشات التوعوية',
            'page_description' => '',
            'sections' => []
        ];
        
        // Helper function to create slug from category title
        $createCategorySlug = function($title) {
            $slugMap = [
                'فيديوهات توعوية (الصناعات المنزلية)' => 'home-industry',
                'فلاشات توعوية (الصحة الحيوانية)' => 'animal-health',
                'سلسلة تعلّم في دقيقة' => 'learn-in-a-minute'
            ];
            
            return $slugMap[$title] ?? $this->createSlug($title);
        };
        
        // Helper function to create general slug
        $createSlug = function($title) {
            // Remove special characters
            $slug = preg_replace('/[^\\p{L}\p{N}\s]/u', '', $title);
            // Replace spaces with hyphens
            $slug = preg_replace('/\s+/', '-', $slug);
            // Convert to lowercase
            $slug = strtolower($slug);
            // Remove extra hyphens
            $slug = preg_replace('/-+/', '-', $slug);
            // Trim hyphens from start and end
            $slug = trim($slug, '-');
            
            return $slug ?: 'awareness-flash';
        };
        
        if ($flashesContent) {
            // Get all content_info records for awareness flashes (these are the categories)
            $flashCategories = \App\Models\ContentInfo::where('content_id', $flashesContent->id)
                ->where('stats', 1)
                ->orderBy('id')
                ->get();
            
            foreach ($flashCategories as $category) {
                $categoryDetail = \App\Models\ContentDetail::where('content_info_id', $category->id)
                    ->where('stats', 1)
                    ->first();
                
                $categoryTitle = trim($category->content);
                $categoryDescription = $categoryDetail ? trim($categoryDetail->additional_info) : '';
                $categoryImage = $categoryDetail ? trim($categoryDetail->URL) : '';
                
                // Determine category slug from title
                $categorySlug = $createCategorySlug($categoryTitle);
                
                // Create section with basic info
                $section = [
                    'id' => $category->id,
                    'title' => $categoryTitle,
                    'description' => $categoryDescription,
                    'image' => $categoryImage ?: '/assets/images/flash-1.png',
                    'slug' => $categorySlug,
                    'link' => '/media/flashes/' . $categorySlug,
                    'videos_count' => 0,
                    'type' => 'awareness_section',
                    'content_type_id' => $category->content_type_id,
                    'created_at' => $category->created_at,
                    'updated_at' => $category->updated_at
                ];
                
                // Try to get videos for this category
                $videoDetails = \App\Models\ContentDetail::where('content_info_id', $category->id)
                    ->where('stats', 1)
                    ->where(function($query) {
                        $query->where('URL', 'like', '%.mp4')
                              ->orWhere('URL', 'like', '%.mov')
                              ->orWhere('URL', 'like', '%.avi')
                              ->orWhere('additional_info', 'like', '%video%');
                    })
                    ->get();
                
                if ($videoDetails->isNotEmpty()) {
                    $section['videos'] = $videoDetails->map(function ($videoDetail) {
                        $videoInfo = json_decode($videoDetail->additional_info, true) ?? [];
                        
                        return [
                            'id' => $videoDetail->id,
                            'title' => $videoInfo['title'] ?? 'فيديو توعوي',
                            'slug' => $videoInfo['slug'] ?? 'video-' . $videoDetail->id,
                            'description' => $videoInfo['description'] ?? '',
                            'duration' => $videoInfo['duration'] ?? '0:00',
                            'thumbnail' => $videoDetail->URL ?: '/assets/images/flash-1.png',
                            'video_url' => $videoInfo['video_url'] ?? $videoDetail->URL,
                            'created_at' => $videoDetail->created_at,
                            'updated_at' => $videoDetail->updated_at
                        ];
                    })->toArray();
                    
                    $section['videos_count'] = count($section['videos']);
                }
                
                $flashesData['sections'][] = $section;
            }
        }
        
        // Map category titles to slugs for the frontend
        $categorySlugMap = [
            'فيديوهات توعوية (الصناعات المنزلية)' => 'home-industry',
            'فلاشات توعوية (الصحة الحيوانية)' => 'animal-health',
            'سلسلة تعلّم في دقيقة' => 'learn-in-a-minute'
        ];
        
        // Ensure all expected categories exist
        $expectedCategories = [
            'فيديوهات توعوية (الصناعات المنزلية)' => [
                'title' => 'فيديوهات توعوية (الصناعات المنزلية)',
                'description' => 'مجموعة فيديوهات توضح خطوات الصناعات الغذائية المنزلية بطريقة آمنة وسهلة.',
                'slug' => 'home-industry',
                'image' => '/assets/images/flash-1.png',
                'link' => '/media/flashes/home-industry',
                'videos_count' => 6
            ],
            'فلاشات توعوية (الصحة الحيوانية)' => [
                'title' => 'فلاشات توعوية (الصحة الحيوانية)',
                'description' => 'مواد مرئية توعوية للحفاظ على صحة المواشي وتحسين الإنتاج.',
                'slug' => 'animal-health',
                'image' => '/assets/images/flash-1.png',
                'link' => '/media/flashes/animal-health',
                'videos_count' => 3
            ],
            'سلسلة تعلّم في دقيقة' => [
                'title' => 'سلسلة تعلّم في دقيقة',
                'description' => 'فيديوهات سريعة تسلط الضوء على مهارات ونصائح لأصحاب المشاريع الصغيرة.',
                'slug' => 'learn-in-a-minute',
                'image' => '/assets/images/flash-1.png',
                'link' => '/media/flashes/learn-in-a-minute',
                'videos_count' => 6
            ]
        ];
        
        // If sections are empty, create from expected categories
        if (empty($flashesData['sections'])) {
            foreach ($expectedCategories as $category) {
                $flashesData['sections'][] = [
                    'id' => 0,
                    'title' => $category['title'],
                    'description' => $category['description'],
                    'image' => $category['image'],
                    'slug' => $category['slug'],
                    'link' => $category['link'],
                    'videos_count' => $category['videos_count'],
                    'type' => 'awareness_section',
                    'created_at' => now(),
                    'updated_at' => now()
                ];
            }
        } else {
            // Ensure we have all expected sections
            $existingTitles = array_column($flashesData['sections'], 'title');
            
            foreach ($expectedCategories as $expectedTitle => $category) {
                if (!in_array($expectedTitle, $existingTitles)) {
                    $flashesData['sections'][] = [
                        'id' => 0,
                        'title' => $category['title'],
                        'description' => $category['description'],
                        'image' => $category['image'],
                        'slug' => $category['slug'],
                        'link' => $category['link'],
                        'videos_count' => $category['videos_count'],
                        'type' => 'awareness_section',
                        'created_at' => now(),
                        'updated_at' => now()
                    ];
                }
            }
            
            // Sort sections to maintain consistent order
            usort($flashesData['sections'], function($a, $b) use ($expectedCategories) {
                $order = array_keys($expectedCategories);
                $posA = array_search($a['title'], $order);
                $posB = array_search($b['title'], $order);
                return $posA - $posB;
            });
        }
        
        return response()->json([
            'success' => true,
            'data' => $flashesData,
            'message' => 'Awareness flashes content fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch awareness flashes content: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch awareness flashes content',
            'error' => $e->getMessage()
        ], 500);
    }
});
// API endpoint to get videos for a specific flash category
Route::get('/flash-videos/{category_slug}', function ($categorySlug) {
    try {
        // Map category slugs to content_info_ids
        $categoryMap = [
            'home-industry' => 19,    // فيديوهات توعوية (الصناعات المنزلية)
            'animal-health' => 20,    // فلاشات توعوية (الصحة الحيوانية)
            'learn-in-a-minute' => 21 // سلسلة تعلّم في دقيقة
        ];
        
        if (!isset($categoryMap[$categorySlug])) {
            return response()->json([
                'success' => false,
                'message' => 'Category not found',
                'data' => null
            ], 404);
        }
        
        $contentInfoId = $categoryMap[$categorySlug];
        
        // Get the content_info record for the category
        $contentInfo = \App\Models\ContentInfo::find($contentInfoId);
        
        if (!$contentInfo) {
            return response()->json([
                'success' => false,
                'message' => 'Category content not found',
                'data' => null
            ], 404);
        }
        
        // Get all videos for this category from content_details
        $videos = \App\Models\ContentDetail::where('content_info_id', $contentInfoId)
            ->where('stats', 1)
            ->orderBy('id')
            ->get()
            ->map(function ($detail) {
                $additionalInfo = json_decode($detail->additional_info, true) ?? [];
                
                return [
                    'id' => $detail->id,
                    'title' => $additionalInfo['title'] ?? 'فيديو توعوي',
                    'slug' => $additionalInfo['slug'] ?? 'video-' . $detail->id,
                    'description' => $additionalInfo['description'] ?? '',
                    'duration' => $additionalInfo['duration'] ?? '0:00',
                    'views' => $additionalInfo['views'] ?? 0,
                    'thumbnail' => $detail->URL ?: '/assets/images/flash-1.png',
                    'video_url' => $additionalInfo['video_url'] ?? $detail->URL,
                    'created_at' => $detail->created_at,
                    'updated_at' => $detail->updated_at
                ];
            });
        
        // Get category info
        $categoryInfo = [
            'home-industry' => [
                'breadcrumbLabel' => 'فيديوهات توعوية (الصناعات المنزلية)',
                'title' => 'فيديوهات توعوية (الصناعات المنزلية)',
                'description' => 'مجموعة فيديوهات توضح خطوات الصناعات الغذائية المنزلية بطريقة آمنة وسهلة.'
            ],
            'animal-health' => [
                'breadcrumbLabel' => 'فلاشات توعوية (الصحة الحيوانية)',
                'title' => 'فلاشات توعوية (الصحة الحيوانية)',
                'description' => 'مواد مرئية توعوية للحفاظ على صحة المواشي وتحسين الإنتاج.'
            ],
            'learn-in-a-minute' => [
                'breadcrumbLabel' => 'سلسلة تعلّم في دقيقة',
                'title' => 'سلسلة تعلّم في دقيقة',
                'description' => 'فيديوهات سريعة تسلط الضوء على مهارات ونصائح لأصحاب المشاريع الصغيرة.'
            ]
        ];
        
        return response()->json([
            'success' => true,
            'data' => [
                'category' => $categoryInfo[$categorySlug] ?? [
                    'breadcrumbLabel' => $contentInfo->content,
                    'title' => $contentInfo->content,
                    'description' => ''
                ],
                'videos' => $videos
            ],
            'message' => 'Videos fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch flash videos: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch flash videos',
            'error' => $e->getMessage()
        ], 500);
    }
});
// API endpoint to get single flash video
Route::get('/flash-video/{category}/{slug}', function ($category, $slug) {
    try {
        // Map category slugs to content_info_ids
        $categoryMap = [
            'home-industry' => 19,    // فيديوهات توعوية (الصناعات المنزلية)
            'animal-health' => 20,    // فلاشات توعوية (الصحة الحيوانية)
            'learn-in-a-minute' => 21 // سلسلة تعلّم في دقيقة
        ];
        
        if (!isset($categoryMap[$category])) {
            return response()->json([
                'success' => false,
                'message' => 'Category not found',
                'data' => null
            ], 404);
        }
        
        $contentInfoId = $categoryMap[$category];
        
        // Get the content_info record for the category
        $contentInfo = \App\Models\ContentInfo::find($contentInfoId);
        
        if (!$contentInfo) {
            return response()->json([
                'success' => false,
                'message' => 'Category content not found',
                'data' => null
            ], 404);
        }
        
        // Get all videos for this category
        $videoDetails = \App\Models\ContentDetail::where('content_info_id', $contentInfoId)
            ->where('stats', 1)
            ->get();
        
        // Find the specific video by slug
        $foundVideo = null;
        
        foreach ($videoDetails as $videoDetail) {
            $videoInfo = json_decode($videoDetail->additional_info, true) ?? [];
            
            // Check if this is the video we're looking for
            if (isset($videoInfo['slug']) && $videoInfo['slug'] === $slug) {
                $foundVideo = [
                    'id' => $videoDetail->id,
                    'title' => $videoInfo['title'] ?? 'فيديو توعوي',
                    'slug' => $videoInfo['slug'] ?? 'video-' . $videoDetail->id,
                    'description' => $videoInfo['description'] ?? '',
                    'category' => $category,
                    'category_name' => $contentInfo->content,
                    'duration' => $videoInfo['duration'] ?? '0:00',
                    'views' => $videoInfo['views'] ?? 0,
                    'thumbnail' => $videoDetail->URL ?: '/assets/images/flash-1.png',
                    'video_url' => $videoInfo['video_url'] ?? $videoDetail->URL,
                    'created_at' => $videoDetail->created_at,
                    'updated_at' => $videoDetail->updated_at,
                    'next_video' => null,
                    'prev_video' => null
                ];
                
                // Find next and previous videos
                $videosList = $videoDetails->map(function ($vd, $index) {
                    $info = json_decode($vd->additional_info, true) ?? [];
                    return [
                        'index' => $index,
                        'id' => $vd->id,
                        'slug' => $info['slug'] ?? 'video-' . $vd->id,
                        'title' => $info['title'] ?? 'فيديو توعوي'
                    ];
                })->toArray();
                
                // Find current video index
                $currentIndex = array_search($videoDetail->id, array_column($videosList, 'id'));
                
                if ($currentIndex !== false) {
                    // Previous video
                    if ($currentIndex > 0) {
                        $prevVideo = $videosList[$currentIndex - 1];
                        $foundVideo['prev_video'] = [
                            'slug' => $prevVideo['slug'],
                            'title' => $prevVideo['title']
                        ];
                    }
                    
                    // Next video
                    if ($currentIndex < count($videosList) - 1) {
                        $nextVideo = $videosList[$currentIndex + 1];
                        $foundVideo['next_video'] = [
                            'slug' => $nextVideo['slug'],
                            'title' => $nextVideo['title']
                        ];
                    }
                }
                
                break;
            }
        }
        
        if (!$foundVideo) {
            return response()->json([
                'success' => false,
                'message' => 'Video not found',
                'data' => null
            ], 404);
        }
        
        return response()->json([
            'success' => true,
            'data' => $foundVideo,
            'message' => 'Video fetched successfully'
        ]);
        
    } catch (\Exception $e) {
        \Log::error('Failed to fetch flash video: ' . $e->getMessage());
        
        return response()->json([
            'success' => false,
            'message' => 'Failed to fetch flash video',
            'error' => $e->getMessage()
        ], 500);
    }
});