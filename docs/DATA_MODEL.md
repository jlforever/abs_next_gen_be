# Table of Contents

1. [Background](#background)
2. [Entities](#entities)

## Background

The Alpha Beta School Next Generation web application hosts a set of data entities related to students, teachers and subject matters interaction in the realm of the application. Below we will go over data entities and relationships among them.

## Entities & Relationships

__Users__

```
id: Bigint
email: Text
first_name: Text
last_name: Text
login: Text
user_name: Text
phone_number: Text
emergency_contact: Text
emergency_contact_phone_number: Text
timezone: Text
created_at: Timestamp
updated_at: Timestamp
```

__Parents__

```
id: Bigint
user_id: Bigint
address: Text
created_at: Timestamp
updated_at: Timestamp
```

__Faculties__

```
id: Bigint
user_id: Bigint
bio: Text
created_at: Timestamp
updated_at: Timestamp
```

__Students__

```
id: Bigint
first_name: Text
last_name: Text
nickname: Text
date_of_birth: Timestamp
age: Bigint
created_at: Timestamp
updated_at: Timestamp
```

__Family Members__

```
id: Bigint
parent_id: Bigint
student_id: Bigint
created_at: Timestamp
updated_at: Timestamp
```

__Specialties__

```
id: Bigint
subject: Text
category: Text
focus_areas: Text
description: Text
created_at: Timestamp
updated_at: Timestamp
```

__Klasses__

```
id: Bigint
specialty_id: Bigint
faculty_id: Bigint
per_session_student_cost: Bigint
per_session_faulty_cut: Bigint
one_sibling_discount_percentage: Float
two_siblings_discount_percentage: Float
taught_via: Text
physical_location_address: Text
number_of_weeks: Bigint
occurs_on_for_a_given_week: Text
individual_session_starts_at: Text
per_session_minutes: Bigint
effective_from: Timestamp
effective_to: Timestamp
created_at: Timestamp
updated_at: Timestamp
one_sibling_same_class_discount_rate Float
two_siblings_same_class_discount_rate Float
virtual_klass_platform_link Text
```

__Registrations__

```
id: Bigint
klass_id: Bigint
primary_family_member_id: Bigint
secondary_family_member_id: Bigint
tertiary_family_member_id: Bigint
status: Text
total_due: Bigint
total_due_by: Bigint
created_at: Timestamp
updated_at: Timestamp
```

__Class Sessions__

```
id: Bigint
registration_id: Bigint
status: Text
effective_for: Timestamp
associate_teaching_session_id: Bigint
created_at: Timestamp
updated_at: Timestamp
```

__Class Session Materials__

```
id: Bigint
name: Text
class_session_id: Bigint
audience: Text
mime_type: Text
teaching_session_student_upload_id: Bigint
created_at: Timestamp
updated_at: Timestamp
```

__Teaching Sessions__

```
id: Bigint
klass_id: Bigint
effective_for: Timestamp
corresponding_class_session_title: Text
created_at: Timestamp
updated_at: Timestamp
```

__Teaching Session Student Uploads__

```
id: Bigint
teaching_session_id: Bigint
name: Text
mime_type: Text
created_at: Timestamp
updated_at: Timestamp
```

__Credit Cards__

```
id: Bigint
user_id: Bigint
card_holder_name: Text
card_last_four: Text
card_type: Text
card_expire_month: Text
card_expire_year: Text
stripe_customer_token: Text
stripe_card_token: Text
postal_identification: Text
created_at: Timestamp
updated_at: Timestamp
```