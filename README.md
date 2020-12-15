# README

Repro for https://github.com/bensheldon/good_job/issues/177

```
$ bundle install
$ bundle exec good_job start

# In another console
$ rails c

# Nothing in the queue to start
irb(main):003:0> puts GoodJob::Job.all.count, GoodJob::Job.finished.count, GoodJob::Job.finished.advisory_locked.count
   (0.4ms)  SELECT COUNT(*) FROM "good_jobs"
   (0.2ms)  SELECT COUNT(*) FROM "good_jobs" WHERE "good_jobs"."finished_at" IS NOT NULL
   (0.6ms)  SELECT COUNT(*) FROM "good_jobs" LEFT JOIN pg_locks ON pg_locks.locktype = 'advisory' AND pg_locks.objsubid = 1 AND pg_locks.classid = ('x' || substr(md5('good_jobs' || "good_jobs"."id"::text), 1, 16))::bit(32)::int AND pg_locks.objid = (('x' || substr(md5('good_jobs' || "good_jobs"."id"::text), 1, 16))::bit(64) << 32)::bit(32)::int WHERE "good_jobs"."finished_at" IS NOT NULL AND "pg_locks"."locktype" IS NOT NULL
0
0
0

# Enqueue 100 jobs
irb(main):004:0> 100.times {|i| LocksReproJob.perform_later(SecureRandom.uuid)}

# Check in on them a minute later
irb(main):006:0> puts GoodJob::Job.all.count, GoodJob::Job.finished.count, GoodJob::Job.finished.advisory_locked.count
   (0.5ms)  SELECT COUNT(*) FROM "good_jobs"
   (0.3ms)  SELECT COUNT(*) FROM "good_jobs" WHERE "good_jobs"."finished_at" IS NOT NULL
   (1.0ms)  SELECT COUNT(*) FROM "good_jobs" LEFT JOIN pg_locks ON pg_locks.locktype = 'advisory' AND pg_locks.objsubid = 1 AND pg_locks.classid = ('x' || substr(md5('good_jobs' || "good_jobs"."id"::text), 1, 16))::bit(32)::int AND pg_locks.objid = (('x' || substr(md5('good_jobs' || "good_jobs"."id"::text), 1, 16))::bit(64) << 32)::bit(32)::int WHERE "good_jobs"."finished_at" IS NOT NULL AND "pg_locks"."locktype" IS NOT NULL
100
100
95

# Enqueue another 100 jobs
irb(main):007:0> 100.times {|i| LocksReproJob.perform_later(SecureRandom.uuid)}

# Check in on them a minute later
irb(main):008:0> puts GoodJob::Job.all.count, GoodJob::Job.finished.count, GoodJob::Job.finished.advisory_locked.count
   (0.5ms)  SELECT COUNT(*) FROM "good_jobs"
   (0.3ms)  SELECT COUNT(*) FROM "good_jobs" WHERE "good_jobs"."finished_at" IS NOT NULL
   (1.5ms)  SELECT COUNT(*) FROM "good_jobs" LEFT JOIN pg_locks ON pg_locks.locktype = 'advisory' AND pg_locks.objsubid = 1 AND pg_locks.classid = ('x' || substr(md5('good_jobs' || "good_jobs"."id"::text), 1, 16))::bit(32)::int AND pg_locks.objid = (('x' || substr(md5('good_jobs' || "good_jobs"."id"::text), 1, 16))::bit(64) << 32)::bit(32)::int WHERE "good_jobs"."finished_at" IS NOT NULL AND "pg_locks"."locktype" IS NOT NULL
200
200
186
=> nil
```
