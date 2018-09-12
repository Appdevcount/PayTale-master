function getAccessToken() {
    alert('Loading');
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
    $.ajax({
        //url: 'http://localhost/PayTale.API/api/Account/UserInfo',
        url: '/PayTale.API/api/Account/UserInfo',
        //url: '/api/Account/UserInfo',
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
        }
    });

}

