
(function(){
  let profile2_id = document.getElementById("match_profile2_id");

  let profiles = Array.from(document.getElementsByClassName('profile'));
  let ids = profiles.map(p => parseInt(p.attributes["profile_id"].value));

  // isn't actually initially selected
  // thi is just a placeholder
  let selected_profile = profiles[0];


  // when a profile is clicked, enter it as the second profile
  // in the hidden form and mark it as selected
  // (and unselect the previously selected one)
  for(let i = 0; i < profiles.length; i++){
    profiles[i].onclick = function(){
      profile2_id.value = ids[i];
      selected_profile.className = "profile";
      profiles[i].className += " selected";
      selected_profile = profiles[i];
    };
  }
})();