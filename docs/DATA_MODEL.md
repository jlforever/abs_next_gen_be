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
