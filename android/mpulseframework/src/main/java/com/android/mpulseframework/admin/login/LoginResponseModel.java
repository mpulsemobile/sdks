package com.android.mpulseframework.admin.login;

public class LoginResponseModel {
    /**
     * accesssToken required for further api to authenticity
     */
    private String accessToken;
    /**
     * tokenType tells you about type of token
     */
    private String tokenType;
    /**
    * Token expiry time
    * */
    private String expiresIn;
    /**
     * Refresh token
     */
    private String refreshToken;

    public String getAccessToken() {
        return accessToken;
    }

    public void setAccessToken(String access_token) {
        this.accessToken = access_token;
    }

    public String getTokenType() {
        return tokenType;
    }

    public void setTokenType(String token_type) {
        this.tokenType = token_type;
    }

    public String getExpiresIn() {
        return expiresIn;
    }

    public void setExpiresIn(String expires_in) {
        this.expiresIn = expires_in;
    }

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }


}
