<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Content extends Model
{
    protected $table = 'Contents';
    protected $primaryKey = 'id';
    
    protected $fillable = [
        'page_id',
        'slug',
        'slug_en',
        'stats'
    ];
    
    public $timestamps = true;
    
    public function page()
    {
        return $this->belongsTo(Page::class, 'page_id', 'id');
    }
    
    public function contentInfos()
    {
        return $this->hasMany(ContentInfo::class, 'content_id', 'id');
    }
}