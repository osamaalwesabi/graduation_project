<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ContentInfo extends Model
{
    protected $table = 'Content_info';
    protected $primaryKey = 'id';
    
    protected $fillable = [
        'content_id',
        'content_type_id',
        'content',
        'content_en',
        'stats'
    ];
    
    public $timestamps = true;
    
    public function content()
    {
        return $this->belongsTo(Content::class, 'content_id', 'id');
    }
    
    public function contentDetail()
    {
        return $this->hasOne(ContentDetail::class, 'content_info_id', 'id');
    }
}