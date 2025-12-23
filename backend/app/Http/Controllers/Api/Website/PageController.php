<?php
// app/Http/Controllers/Api/Website/PageController.php
namespace App\Http\Controllers\Api\Website;

use App\Http\Controllers\Controller;
use App\Models\Page;
use App\Models\Content;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class PageController extends Controller
{
    public function index(Request $request)
    {
        $pages = Page::active()
            ->with(['contents' => function($query) {
                $query->active()->with(['mainContentInfo.contentType']);
            }])
            ->get()
            ->map(function($page) {
                return [
                    'id' => $page->id,
                    'name' => $page->name, // Uses accessor for locale
                    'page_name' => $page->page_name,
                    'page_name_en' => $page->page_name_en,
                    'contents' => $page->contents->map(function($content) {
                        return [
                            'id' => $content->id,
                            'slug' => $content->slug, // Uses accessor for locale
                            'content_info' => $content->mainContentInfo ? [
                                'id' => $content->mainContentInfo->id,
                                'title' => $content->mainContentInfo->title,
                                'content_type' => $content->mainContentInfo->contentType ? [
                                    'id' => $content->mainContentInfo->contentType->id,
                                    'type' => $content->mainContentInfo->contentType->type,
                                ] : null,
                            ] : null,
                        ];
                    }),
                    'created_at' => $page->created_at,
                    'updated_at' => $page->updated_at,
                ];
            });
        
        return response()->json([
            'success' => true,
            'data' => $pages,
            'locale' => App::getLocale(),
        ]);
    }
    
    public function show($id)
    {
        $page = Page::active()->findOrFail($id);
        
        // Load contents with their full hierarchy
        $page->load(['contents' => function($query) {
            $query->active()->with([
                'contentInfos' => function($q) {
                    $q->active()->with(['contentType', 'contentDetails']);
                }
            ]);
        }]);
        
        return response()->json([
            'success' => true,
            'data' => [
                'id' => $page->id,
                'name' => $page->name,
                'page_name' => $page->page_name,
                'page_name_en' => $page->page_name_en,
                'contents' => $page->contents->map(function($content) {
                    return [
                        'id' => $content->id,
                        'slug' => $content->slug,
                        'slug_en' => $content->slug_en,
                        'content_infos' => $content->contentInfos->map(function($info) {
                            return [
                                'id' => $info->id,
                                'content' => $info->content,
                                'content_en' => $info->content_en,
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
                            ];
                        }),
                    ];
                }),
            ],
            'locale' => App::getLocale(),
        ]);
    }
    
    public function contents(Page $page)
    {
        $contents = Content::where('page_id', $page->id)
            ->active()
            ->with(['contentInfos' => function($query) {
                $query->active()->with(['contentType', 'contentDetails']);
            }])
            ->get();
        
        return response()->json([
            'success' => true,
            'data' => $contents,
        ]);
    }
}