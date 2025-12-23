<?php
// app/Models/ContentType.php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ContentType extends Model
{
    protected $table = 'Content_Type';
    protected $primaryKey = 'id';
    
    protected $fillable = ['type', 'type_en', 'stats'];
    
    protected $casts = [
        'stats' => 'integer',
    ];
    
    public function contentInfos()
    {
        return $this->hasMany(ContentInfo::class, 'content_type_id');
    }
    
    // Get type name based on locale
    public function getTypeAttribute($value)
    {
        $locale = app()->getLocale();
        return $locale === 'en' && $this->type_en 
            ? $this->type_en 
            : $value;
    }
    
    public function scopeActive($query)
    {
        return $query->where('stats', 1);
    }
}