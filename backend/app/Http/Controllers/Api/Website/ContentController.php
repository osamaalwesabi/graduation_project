<?php
// app/Http/Controllers/Api/Website/ContentController.php
namespace App\Http\Controllers\Api\Website;

use App\Http\Controllers\Controller;
use App\Models\Content;
use App\Models\ContentType;
use App\Models\Page;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class ContentController extends Controller
{
    public function index(Request $request)
    {
        $query = Content::active()->withPage();
        
        // Filter by content type
        if ($request->has('content_type_id')) {
            $query->whereHas('contentInfos', function($q) use ($request) {
                $q->where('content_type_id', $request->content_type_id);
            });
        }
        
        // Filter by page
        if ($request->has('page_id')) {
            $query->where('page_id', $request->page_id);
        }
        
        // Search by slug
        if ($request->has('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('slug', 'like', "%{$search}%")
                  ->orWhere('slug_en', 'like', "%{$search}%");
            });
        }
        
        // Load content info with details
        $query->with(['page', 'contentInfos' => function($q) {
            $q->active()->with(['contentType', 'contentDetails']);
        }]);
        
        // Paginate
        $perPage = $request->get('per_page', 10);
        $contents = $query->paginate($perPage);
        
        // Transform data
        $transformedContents = $contents->getCollection()->map(function($content) {
            return $this->transformContent($content);
        });
        
        return response()->json([
            'success' => true,
            'data' => $transformedContents,
            'meta' => [
                'current_page' => $contents->currentPage(),
                'last_page' => $contents->lastPage(),
                'per_page' => $contents->perPage(),
                'total' => $contents->total(),
            ],
            'locale' => App::getLocale(),
        ]);
    }
    
    public function show($id)
    {
        $content = Content::active()
            ->withPage()
            ->with(['page', 'contentInfos' => function($q) {
                $q->active()->with(['contentType', 'contentDetails']);
            }])
            ->findOrFail($id);
        
        return response()->json([
            'success' => true,
            'data' => $this->transformContent($content, true),
            'locale' => App::getLocale(),
        ]);
    }
    
    public function showBySlug($slug)
    {
        $locale = App::getLocale();
        
        // Determine which slug column to search based on locale
        if ($locale === 'en') {
            $content = Content::where('slug_en', $slug);
        } else {
            $content = Content::where('slug', $slug);
        }
        
        $content = $content->active()
            ->withPage()
            ->with(['page', 'contentInfos' => function($q) {
                $q->active()->with(['contentType', 'contentDetails']);
            }])
            ->firstOrFail();
        
        return response()->json([
            'success' => true,
            'data' => $this->transformContent($content, true),
            'locale' => $locale,
        ]);
    }
    
    public function byType($typeId)
    {
        $contents = Content::active()
            ->withPage()
            ->whereHas('contentInfos', function($q) use ($typeId) {
                $q->where('content_type_id', $typeId)->active();
            })
            ->with(['page', 'contentInfos' => function($q) use ($typeId) {
                $q->where('content_type_id', $typeId)->active()->with(['contentType', 'contentDetails']);
            }])
            ->get()
            ->map(function($content) {
                return $this->transformContent($content);
            });
        
        return response()->json([
            'success' => true,
            'data' => $contents,
            'locale' => App::getLocale(),
        ]);
    }
    
    public function byPage($pageId)
    {
        $contents = Content::where('page_id', $pageId)
            ->active()
            ->with(['page', 'contentInfos' => function($q) {
                $q->active()->with(['contentType', 'contentDetails']);
            }])
            ->get()
            ->map(function($content) {
                return $this->transformContent($content);
            });
        
        return response()->json([
            'success' => true,
            'data' => $contents,
            'locale' => App::getLocale(),
        ]);
    }
    
    public function types()
    {
        $types = ContentType::active()->get();
        
        return response()->json([
            'success' => true,
            'data' => $types->map(function($type) {
                return [
                    'id' => $type->id,
                    'type' => $type->type, // Uses accessor
                    'type_en' => $type->type_en,
                    'created_at' => $type->created_at,
                ];
            }),
            'locale' => App::getLocale(),
        ]);
    }
    
    /**
     * Transform content for API response
     */
    private function transformContent(Content $content, $fullDetails = false)
    {
        $data = [
            'id' => $content->id,
            'slug' => $content->slug,
            'slug_en' => $content->slug_en,
            'page' => $content->page ? [
                'id' => $content->page->id,
                'name' => $content->page->name,
            ] : null,
        ];
        
        if ($fullDetails) {
            $data['content_infos'] = $content->contentInfos->map(function($info) {
                return [
                    'id' => $info->id,
                    'content' => $info->content,
                    'content_en' => $info->content_en,
                    'title' => $info->title,
                    'content_type' => $info->contentType ? [
                        'id' => $info->contentType->id,
                        'type' => $info->contentType->type,
                        'type_en' => $info->contentType->type_en,
                    ] : null,
                    'details' => $info->contentDetails->map(function($detail) {
                        return [
                            'id' => $detail->id,
                            'url' => $detail->URL,
                            'additional_info' => $detail->additional_info,
                            'additional_info_en' => $detail->additional_info_en,
                        ];
                    }),
                    'created_at' => $info->created_at,
                    'updated_at' => $info->updated_at,
                ];
            });
        } else {
            // Just get the first/main content info for listing
            $mainInfo = $content->contentInfos->first();
            $data['content_info'] = $mainInfo ? [
                'id' => $mainInfo->id,
                'title' => $mainInfo->title,
                'content_type' => $mainInfo->contentType ? [
                    'id' => $mainInfo->contentType->id,
                    'type' => $mainInfo->contentType->type,
                ] : null,
            ] : null;
        }
        
        $data['created_at'] = $content->created_at;
        $data['updated_at'] = $content->updated_at;
        
        return $data;
    }
}