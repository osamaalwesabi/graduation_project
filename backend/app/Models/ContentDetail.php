<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ContentDetail extends Model
{
    protected $table = 'Content_details';
    protected $primaryKey = 'id';
    
    protected $fillable = [
        'content_info_id',
        'URL',
        'additional_info',
        'additional_info_en',
        'stats'
    ];
    
    public $timestamps = true;
    
    public function contentInfo()
    {
        return $this->belongsTo(ContentInfo::class, 'content_info_id', 'id');
    }
}