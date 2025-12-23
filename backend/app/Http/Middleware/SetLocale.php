<?php
// app/Http/Middleware/SetLocale.php
namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\App;

class SetLocale
{
    public function handle(Request $request, Closure $next)
    {
        // Get locale from query parameter, header, or default to config
        $locale = $request->query('lang') 
                 ?: $request->header('Accept-Language') 
                 ?: config('app.locale');
        
        // Support both 'en' and 'ar' or other languages
        if (in_array($locale, ['en', 'ar', 'fr', 'es'])) { // Add your supported languages
            App::setLocale($locale);
        }
        
        return $next($request);
    }
}