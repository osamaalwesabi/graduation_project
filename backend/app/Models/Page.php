<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;


class Page extends Model
{
    protected $table = 'Pages';
    protected $primaryKey = 'id';
    
    protected $fillable = [
        'page_name', 'page_name_en', 'stats'
    ];
    
    protected $casts = [
        'stats' => 'integer', // 1 = active, 0 = inactive probably
    ];
    
    public function contents()
    {
        return $this->hasMany(Content::class, 'page_id');
    }
    
    // Helper method to get name based on locale
    public function getNameAttribute()
    {
        $locale = app()->getLocale();
        return $locale === 'en' && $this->page_name_en 
            ? $this->page_name_en 
            : $this->page_name;
    }
    
    public function scopeActive($query)
    {
        return $query->where('stats', 1);
    }
}