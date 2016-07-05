# 다음 카페 API 호줄하기

두가지 방법이 있다. 하나는 OAuth 인증, 다른 하나는 API Key 호출

## OAuth 인증

[OAuth 2.0 참조하기](http://developers.daum.net/services/apis/docs/oauth2_0/reference)
[Github Sample Code](https://github.com/daumdna)

### API Key 및 OAuth 준비 작업

![](http://i.imgur.com/Zzw9KCD.png)

### API 호출 after OAuth 인증

[코드참조](https://github.com/daumdna/apis/tree/master/Samples/4.Cafe/1.Basic/DotNet)

### API 호출 with API Key

예를 들어 최신글 보기는 다음과 같이 호출하면 된다. 

```
curl -Uri "https://apis.daum.net/cafe/v1/recent_articles/DFWA.json?appkey={your_apikey}"
```
![그렇다. 난 단지 낚시 카페의 최신글이 보고 싶었을 뿐이다. RSS 없앤 Daum 나쁜 놈들..](http://i.imgur.com/kTUF4vV.jpg)

참고로, [Daum Developers](http://developers.daum.net/services/apis/cafe/v1/recent_articles/cafeCode.format)에서는 OAuth 를 통한 예제만 나와 있고, {apikey}도 쓸수 있다고 되어 있는데.. 당연히 `apikey` 일거라 생각했는데 `appkey` 를 써야 하는거였다. 
