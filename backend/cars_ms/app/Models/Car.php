<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Car extends Model
{
    protected $fillable = [
        'name',
        'model',
        'price',
        'availability_status'
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'availability_status' => 'boolean'
    ];
}