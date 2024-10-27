<?php
namespace App\Services;

use Illuminate\Support\Facades\Http;

class AuthService
{
    public function validateToken($token)
    {
        $response = Http::withHeaders([
            'Authorization' => 'Bearer ' . $token
        ])->get(config('services.auth.base_uri') . '/api/validate-token');

        return $response->successful();
    }
}
