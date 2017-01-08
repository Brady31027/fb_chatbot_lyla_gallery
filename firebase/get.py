from firebase import firebase
firebase = firebase.FirebaseApplication('https://lyla-gallery-db.firebaseio.com/', None)

# followings are query samples

table_result = firebase.get('/gallery', None)
first_data_result = firebase.get('/gallery/1', None)
first_title_result = firebase.get('/gallery/1/title', None)
first_subtitle_result = firebase.get('/gallery/1/subtitle', None)
first_img_url_result = firebase.get('/gallery/1/img_url', None)
first_story_result = firebase.get('/gallery/1/story', None)

'''
print "title: %s"%(first_title_result)
print "subtitle: %s"%(first_subtitle_result)
print "img url: %s"%(first_img_url_result)
print "story: %s"%(first_story_result)
'''

# actually we don't have to query data level by level
# use hirachical query by applying the second parameter
# samples
multilevel_data = firebase.get('/gallery/1', 'title')
'''
print multilevel_data
'''