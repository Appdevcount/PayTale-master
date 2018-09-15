function Google() {


    var Prod = 'true';
    var ApiurlforGoogle = '';
    var ProviderDetails = '';
    var redirect_uri = '';
    var state = '';
    if (Prod == 'true') {
        //var ApiurlforGoogle = "http://localhost/PayTale.API/api/Account/ExternalLogin?";
        //var ApiurlforGoogle = "http://localhost:54628/api/Account/ExternalLogin?";
        //var ApiurlforGoogle = "/api/Account/ExternalLogin?";
        ApiurlforGoogle = "/PayTale.API/api/Account/ExternalLogin?";
        ProviderDetails = "provider=Google&response_type=token&client_id=self&";
        //var redirect_uri = "redirect_uri=http://localhost/PayTale.API/Auth/SignInGoogle";
        redirect_uri = "redirect_uri=http%3A%2F%2Flocalhost%2FPayTale.API%2FAuth%2FSignInGoogle";
        //var redirect_uri = "redirect_uri=http%3A%2F%2Flocalhost%3A54628%2FAuth%2FSignInGoogle";
        //WEBApp RedirectURI below
        //redirect_uri = "redirect_uri=http%3A%2F%2Flocalhost%2FPayTale.WEB%2FHome%2FAbout";
        state = "&state=w-srodOj8zrE40v0GRuzv8gGoEbdUAyWF2L_LQckQHI1";
        //http://localhost:54628/api/Account/ExternalLogin?provider=Google&response_type=
        //token&client_id=self&redirect_uri=http%3A%2F%2Flocalhost%3A54628%2F&
        //    state=9hxuHvfBkoHkjjCgg5URPwTa-NCZaUxqWGWAOyBI9v41

    }
    else {
        //var ApiurlforGoogle = "http://localhost/PayTale.API/api/Account/ExternalLogin?";
        //var ApiurlforGoogle = "http://localhost:54628/api/Account/ExternalLogin?";
        ApiurlforGoogle = "/api/Account/ExternalLogin?";
        //ApiurlforGoogle = "/PayTale.API/api/Account/ExternalLogin?";
        ProviderDetails = "provider=Google&response_type=token&client_id=self&";
        //var redirect_uri = "redirect_uri=http://localhost/PayTale.API/Auth/SignInGoogle";
        //redirect_uri = "redirect_uri=http%3A%2F%2Flocalhost%2FPayTale.API%2FAuth%2FSignInGoogle";
        redirect_uri = "redirect_uri=http%3A%2F%2Flocalhost%3A54628%2FAuth%2FSignInGoogle";
        state = "&state=w-srodOj8zrE40v0GRuzv8gGoEbdUAyWF2L_LQckQHI1";
        //http://localhost:54628/api/Account/ExternalLogin?provider=Google&response_type=
        //token&client_id=self&redirect_uri=http%3A%2F%2Flocalhost%3A54628%2F&
        //    state=9hxuHvfBkoHkjjCgg5URPwTa-NCZaUxqWGWAOyBI9v41

    }

    ///api/Account/ExternalLogin?provider=Google&response_type=token&client_id=self&redirect_uri=http%3A%2F%2Flocalhost%3A54628%2F&state=yemp000P4Kb5rbYXFTFBtxB7sv8t3PHyWQlxLgts1HE1

    var URL = ApiurlforGoogle + ProviderDetails + redirect_uri + state;
    //var EURL = "http%3A%2F%2Flocalhost%3A54628%2Fapi%2FAccount%2FExternalLogin%3Fprovider%3DGoogle%26response_type%3Dtoken%26client_id%3Dself%26redirect_uri%3Dhttp%3A%2F%2Flocalhost%3A54628%2FAuth%2FSignInGoogle%26state%3D9hxuHvfBkoHkjjCgg5URPwTa-NCZaUxqWGWAOyBI9v41";
    console.log(URL);//"http://localhost:54628/api/Account/ExternalLogin?provider=Google&response_type=token&client_id=self&redirect_uri=http%3A%2F%2Flocalhost%3A54628%2F&state=9hxuHvfBkoHkjjCgg5URPwTa-NCZaUxqWGWAOyBI9v41");

    //window.location.href = "http://localhost:54628/api/Account/ExternalLogin?provider=Google&response_type=token&client_id=self&redirect_uri=http%3A%2F%2Flocalhost%3A54628%2F&state=9hxuHvfBkoHkjjCgg5URPwTa-NCZaUxqWGWAOyBI9v41";
    window.location.href = URL;
}




function getAccessToken() {

    if (localStorage.getItem('accessToken') == null) {
        window.location.href = "/PayTale.API/ExternalAuth.html";
    }
    //alert('Loading');
    if (location.hash) {
        if (location.hash.split('access_token=')) {
            var accessToken = location.hash.split('access_token=')[1].split('&')[0];
            if (accessToken) {
                isUserRegistered(accessToken);
            }
        }
    }
}




function isUserRegistered(accessToken) {
    //alert('CheckingUserRegistration')
    $.ajax({
        //url: 'http://localhost/PayTale.API/api/Account/UserInfo',
        url: '/PayTale.API/api/Account/UserInfo',
        //url: '/api/Account/UserInfo',
        //url: 'http://localhost:54628/api/Account/UserInfo',
        method: 'GET',
        headers: {
            'content-type': 'application/JSON',
            'Authorization': 'Bearer ' + accessToken
        },
        success: function (response) {
            if (response.HasRegistered) {
                localStorage.setItem('accessToken', accessToken);
                localStorage.setItem('userName', response.Email);
                //window.location.href = "Data.html";
            }
            else {
                signupExternalUser(accessToken);
            }
        }
    });
}





function signupExternalUser(accessToken) {
    //alert('RegisteringUser')
    $.ajax({
        //url: 'http://localhost/PayTale.API/api/Account/RegisterExternal',
        url: '/PayTale.API/api/Account/RegisterExternal',
        //url: '/api/Account/RegisterExternal',
        method: 'POST',
        headers: {
            'content-type': 'application/json',
            'Authorization': 'Bearer ' + accessToken
        },
        success: function () {
            //window.location.href = "/PayTale.API/api/Account/ExternalLogin?provider=Google&response_type=token&client_id=self&redirect_uri=http%3a%2f%2flocalhost%3a61358%2fLogin.html&state=GerGr5JlYx4t_KpsK57GFSxVueteyBunu02xJTak5m01";
            alert('SignUpSuccess');
            //alert(response)
        }
    });

}




function LogOut() {
    localStorage.removeItem('accessToken');
    window.location.href = "/PayTale.API/ExternalAuth.html";

    alert('LoggingOut')
    $.ajax({
        //url: 'http://localhost/PayTale.API/api/Account/LogOut',
        url: '/PayTale.API/api/Account/LogOut',
        //url: '/api/Account/RegisterExternal',
        method: 'POST',
        headers: {
            'content-type': 'application/json',
            //'Authorization': 'Bearer ' + accessToken
        },
        success: function () {
            //window.location.href = "/PayTale.API/api/Account/ExternalLogin?provider=Google&response_type=token&client_id=self&redirect_uri=http%3a%2f%2flocalhost%3a61358%2fLogin.html&state=GerGr5JlYx4t_KpsK57GFSxVueteyBunu02xJTak5m01";
            alert('LoggedOut');
            //alert(response)
        }
    });

}


